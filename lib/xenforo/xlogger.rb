require 'logger'

module Xenforo
  module XLogger
    def self.get_logger(program_file)
      log_file = File.expand_path(File.join(File.dirname(program_file), '..', 'log', File.basename(program_file) + '.log'))
      logger = Logger.new MultiIO.new(STDOUT, File.open(log_file, 'w'))
      logger.level = Logger::INFO
      logger.info "Logging to: #{log_file}"
      logger
    end
  end

  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each { |t| t.write(*args) }
    end

    def close
      @targets.each(&:close)
    end
  end
end
