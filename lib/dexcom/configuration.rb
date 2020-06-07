# frozen_string_literal: true

module Dexcom
  class Configuration
    attr_accessor :username, :password, :outside_usa

    def initialize
      @username = nil
      @password = nil
      @outside_usa = nil
    end

    def base_url
      outside_usa ? URL_BASE_OUTSIDE_USA : URL_BASE
    end
  end
end
