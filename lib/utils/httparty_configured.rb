# frozen_string_literal: true

require 'httparty'

require 'dexcom/configuration'

module Utils
  module HTTPartyConfigured
    include HTTParty

    config = Dexcom.configuration

    unless config.logger.nil?
      logger config.logger, config.log_level, :apache
      debug_output config.logger if config.log_level == :debug
    end
  end
end
