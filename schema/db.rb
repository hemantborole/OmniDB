LIB_DIR = File.join(File.dirname(__FILE__),'..','lib')
require File.join(LIB_DIR, 'db_utils')
require File.join(LIB_DIR,'omni_db', 'config')
require File.join('sequel','extensions','query')

class DB
  ## Sequelize the above schema 
  include OmniDb
  def self.create_db

		connection = DbUtils.connection
    params = Config.config_hash['storagedb']
		dbname = params['dbname']

		connection << " create database #{dbname}"
		connection << " use #{dbname} "
		connection << "
				create table cache (
					id varchar(255) primary key,
					name varchar(255) unique,
					value varchar(255),
					end_ts timestamp default 0,
					create_by varchar(255)
				)"
  
  end
end
DB.create_db
