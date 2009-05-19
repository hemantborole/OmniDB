lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir, 'db_utils')

class Writer

	CACHE_OBJECT_SIZE = 5000
	LIFE_TIME = 1800 # seconds
	attribute_accessor :db_handle

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

	private

	def db_write(key, value, life_time = LIFE_TIME)
		@dbhandle ||= DbUtils.connect_to_db(dbname)
		end_ts = Time.now + life_time
		connection << "insert into cache('name','value','end_ts','create_by') values( #{key}, #{value}, #{end_ts}, 'dummy' )"
	end

	def cache_write(key, value, life_time = LIFE_TIME)
		return if value.size > 5000
		return if life_time <= 0
		DHTCache.hash_in(key, value, life_time)
	end

end
