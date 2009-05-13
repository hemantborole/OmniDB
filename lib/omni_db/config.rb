require 'yaml'
require 'erb'

module OmniDb
  class Config
    @config_file = File.join('configs', 'config.yml')

    def self.config_hash
      @@config_hash ||= YAML.load(ERB.new(File.read(@config_file)).result)
    end

    def self.config_file=(filename)
      @config_file = filename
    end
  end
end

# p OmniDb::Config.config_hash
