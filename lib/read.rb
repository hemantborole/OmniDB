lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir, 'init_cache')
require File.join(lib_dir, 'constants')
require File.join(lib_dir, 'x_handler')

class Reader
  include OmniDb

	def get_dbhandle
		params = Config.config_hash['storagedb']
		@dbhandle ||= DbUtils.connect_to_db(params['dbname'])
	end

	def fallback( key )
		cache_set = get_dbhandle[:cache].where( :name => key )
	end
	attr_accessor :dbhandle
end
