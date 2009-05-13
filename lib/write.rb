lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir, 'db_utils')

class Writer

	attribute_accessor :db_handle

	LIFE_TIME = 1800 # seconds
	def db_write(key, value, life_time = LIFE_TIME)
		@dbhandle ||= DbUtils.connect_to_db(dbname)
		end_ts = Time.now + life_time
		connection << "insert into cache values( #{@id}, #{key}, #{value})"
		@id += 1
	end

	def cache_write
		
	end

	private
	@id = 0

end
