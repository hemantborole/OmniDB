lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'daemon')
require File.join(lib_dir, 'constants')

require 'rubygems'
require 'memcache'
require 'singleton'

class DHTCache
	def self.hash_in(key, value, life_time = LIFE_TIME)
		CACHE.set(key, value, life_time)
	end

	def self.hash_out(key)
		CACHE.get(key)
	end

	private
  include OmniDb
  include Singleton

  params = Config.config_hash['cachedb']
  CACHE = MemCache.new
  CACHE.servers = params['host']

end
