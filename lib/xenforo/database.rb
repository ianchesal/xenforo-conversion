require 'sequel'
require 'logger'
require 'yaml'

module Xenforo
  # Constructs a Sequel DB connection to your Xenforo database using
  # .config/database.yml-based connection information. Can also connect
  # to VBulletin databases.
  class Database
    attr_reader :settings, :logger, :type

    def initialize(type: 'xenforo', logger: nil)
      if logger
        self.logger = logger
      else
        self.logger = Logger.new(STDOUT)
        self.logger.level = Logger::ERROR
      end
      load_yaml(type)
    end

    def connect
      @connect ||= Sequel.connect(adapter: dbtype, user: username, password: password, host: host, port: port, database: database_name, logger: logger)
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

    attr_writer :settings, :logger, :type

    def config_file
      File.join(File.dirname(__FILE__), '..', '..', '.config', 'database.yml')
    end

    def load_yaml(type)
      data = YAML.safe_load(File.open(config_file))
      raise "Missing #{type} section in database.yml" unless data.key? type

      %w[host port username password type database].each do |setting|
        raise "Missing database configuration setting #{setting}" unless data[type].key? setting
      end
      self.type = type
      self.settings = data[type]
    end
  end
end
