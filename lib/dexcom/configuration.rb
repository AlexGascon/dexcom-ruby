# frozen_string_literal: true

module Dexcom
  class Configuration
    attr_accessor :username, :password, :outside_usa, :logger, :log_level

    DEFAULT_LOGGER = nil
    DEFAULT_LOGGER_LEVEL = :info

    def initialize
      @username = nil
      @password = nil
      @outside_usa = nil
      @logger = DEFAULT_LOGGER
      @log_level = DEFAULT_LOGGER_LEVEL
    end

    def base_url
      outside_usa ? URL_BASE_OUTSIDE_USA : URL_BASE
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configuration=(config)
      raise StandardError('Invalid configuration provided') unless config.is_a? Dexcom::Configuration

      @configuration = config
    end

    def configure
      yield configuration
    end
  end
end
