%w{rubygems sequel}.each {|r| require r}
lib_dir = File.join(File.dirname(__FILE__),'..','lib')
require File.join(lib_dir,'omni_db', 'config')

class DbUtils

  attr_reader :connection
  include OmniDb

	def self.connect_to_db(dbname)
		params = Config.config_hash['storagedb']
		dbname = params['dbname']
		conn = connection
		conn << "use #{dbname}"
		conn
	end

  def self.connection(dbname = nil)
    @connection ||= create_connection {|params|

      raise Exception.new('Invalid Adapter') unless params['adapter']
      adapter = params['adapter']

      case
        when adapter.match(/^mysql$/i)
          raise Exception.new('Invalid or unspecified host') unless params['host']

					url = "#{adapter}://#{params['username']}"
					url += ":#{params['password']}" if params['password']
					url += "@#{params['host']}"
					url += ":" + ( params['port'] || 3306 ).to_s
					url += "/#{dbname}" if dbname
					#url += "/#{params['dbname']}"

					p "Connecting to database #{url}"

          db_conn = Sequel.connect(url)
        when adapter.match(/^sqlite$/i)
          if params['dbname'] && File.exist?(params['dbname'])
            db_conn = Sequel.sqlite(params['dbname'])
          else
            db_conn = Sequel.sqlite
          end
        else
          raise Exception.new("Unsupported db adapter #{adapter}")
      end
    }
  end

  private
  def self.create_connection
    params = Config.config_hash['storagedb']
    begin
      yield params
    rescue => e
      p("Error creating database connection: #{e.message}")
    end
  end

end

#p "Got connection #{DbUtils.connection.inspect}"
