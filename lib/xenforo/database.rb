require 'sequel'
require 'logger'
require 'yaml'

module Xenforo
  # Constructs a Sequel DB connection to your Xenforo database using
  # .config/database.yml-based connection information.
  class Database
    attr_reader :settings, :logger

    def initialize(logfile = nil)
      if logfile
        self.logger = Logger.new(logfile)
        logger.level = Logger::DEBUG
      else
        self.logger = Logger.new(STDOUT)
        logger.level = Logger::ERROR
      end
      load_yaml
    end

    def connect
      Sequel.connect(adapter: dbtype, user: username, password: password, host: host, port: port, database: database_name, logger: logger)
    end

    def url
      "#{dbtype}://#{username}:#{password}@#{host}/#{database_name}"
    end

    def dbtype
      return 'mysql2' if settings['type'] == 'mysql'
      settings['type']
    end

    def username
      settings['username']
    end

    def password
      settings['password']
    end

    def host
      settings['host']
    end

    def port
      settings['port']
    end

    def database_name
      settings['database']
    end

    private

    attr_writer :settings, :logger

    def config_file
      File.join(File.dirname(__FILE__), '..', '..', '.config', 'database.yml')
    end

    def load_yaml
      self.settings = YAML.load(File.open(config_file))
      %w(host port username password type database).each do |setting|
        fail "Missing database configuration setting #{setting}" unless settings.key? setting
      end
    end
  end
end
