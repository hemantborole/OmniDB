lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'daemon')

require 'rubygems'
require 'memcache'
require 'singleton'

class DHTCache
	private
  include OmniDb
  include Singleton

  params = Config.config_hash['cachedb']
  CACHE = MemCache.new
  CACHE.servers = params['host']
	LIFE_TIME = 1800	# seconds

	public
	def self.hash_in(key, value, life_time = LIFE_TIME
		CACHE.set(key, value, life_time)
	end

	def self.hash_out
		CACHE.get(key)
	end
end
