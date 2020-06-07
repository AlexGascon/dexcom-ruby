# frozen_string_literal: true

require 'dexcom/configuration'
require 'dexcom/utils'
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
