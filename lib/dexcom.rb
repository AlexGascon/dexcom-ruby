# frozen_string_literal: true

require 'dexcom/authentication'
require 'dexcom/blood_glucose'
require 'dexcom/configuration'
require 'dexcom/constants'
require 'dexcom/version'

module Dexcom
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
