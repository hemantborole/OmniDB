lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir, 'init_cache')

class Writer

  include OmniDb
	CACHE_OBJECT_SIZE = 5000
	LIFE_TIME = 1800 # seconds

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
		end_ts = (Time.now + life_time).to_s
		cache_set.insert(:name => key, :value => value, :end_ts => end_ts, :create_by => 'dummy')
	end

	def cache_write(key, value, life_time = LIFE_TIME)
		return unless value
		return if value.length > 5000
		return if life_time <= 0
		DHTCache.hash_in(key, value, life_time)
	end

end
