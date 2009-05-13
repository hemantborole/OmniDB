lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir, 'db_utils')
require File.join(lib_dir,'omni_db', 'config')
require File.join(lib_dir, 'daemon')
require 'singleton'

class Cleaner < Daemon::Base
	include Singleton
  include OmniDb

  params = Config.config_hash['storagedb']
  @connection = DbUtils.connection
  @interval = params['cleanup_interval'].to_i
  @interval = 5 if @interval <= 0
  @dbname = params['dbname']
  @d_log = File.open("cleaner.log","a")

  def self.start

    @bb = 0
    @connection << "use #{@dbname}"
    @d_log.puts( "STARTIGN CLEANER WITH INTERVAL #{@interval}" )
    @d_log.flush
    loop do
      @bb += 1
      time_now = Time.now
      @connection << "delete from cache where end_ts < '" + time_now.to_s + "'"
      sleep @interval
    end
  end

  def self.stop
    @d_log.puts( "Cleaner is stopping..#{@bb}" )
    @d_log.close
  end

  self.daemonize

end
