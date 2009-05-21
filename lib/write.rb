lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir, 'init_cache')
require File.join(lib_dir, 'constants')
require File.join(lib_dir, 'x_handler')

class Writer

  include OmniDb
	CACHE_OBJECT_SIZE = 5000

	public
	def atomic_write(key, value, life_time = LIFE_TIME)
		 Mutex.new.synchronize do
			async_write(key, value, life_time)
		 end
	end

	def async_write(key, value, life_time = LIFE_TIME)
		 threads = []
		 threads << Thread.new { db_write(key, value, life_time) }
		 threads << Thread.new { cache_write(key, value, life_time) }
		 threads.each {|t| t.join }
	end

  ## If for some reason the cache server went down, and it is restarted then
  ## the cache must be refilled with values from the storage server.
  def refill
    now = Time.now.to_i
    require 'ruby-debug'; debugger
    cache_set.each {|rec|
      ttl = rec.life_time.to_i - now
      cache_write( rec.key, rec.value, ttl ) if ttl > 0 \
          if rec.value and rec.value.length > MAX_OBJ_SIZE and ttl > 0
    }
  end


	attr_accessor :dbhandle, :cache_set

	private

	def dbhandle
		params = Config.config_hash['storagedb']
		@dbhandle ||= DbUtils.connect_to_db(params['dbname'])
	end

	def cache_set
		@cache_set ||= dbhandle[:cache]
	end

	def db_write(key, value, life_time = LIFE_TIME)
    begin
		  end_ts = (Time.now + life_time).to_s
		  cache_set.insert( :name => key, :value => value, :end_ts => end_ts,
                :create_by => 'dummy')
    rescue Sequel::DatabaseError => exc
      raise ExistsException.new("Record already exists: #{exc.message}")
    end
	end

	def cache_write(key, value, life_time = LIFE_TIME)
		return unless value
		return if value.length > MAX_OBJ_SIZE
		return if life_time <= 0
		DHTCache.hash_in(key, value, life_time)
	end

end
