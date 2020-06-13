# frozen_string_literal: true

require 'dexcom/blood_glucose/api_handler'
require 'dexcom/blood_glucose/class_methods'

module Dexcom
  class BloodGlucose
    extend BloodGlucoseUtils::ApiHandler
    extend BloodGlucoseUtils::ClassMethods

    MGDL_TO_MMOL_FACTOR = 0.0555

    TRENDS = {
      0 => { symbol: '', description: '' },
      1 => { symbol: '↑↑', description: 'Rising quickly' },
      2 => { symbol: '↑', description: 'Rising' },
      3 => { symbol: '↗', description: 'Rising slightly' },
      4 => { symbol: '→', description: 'Steady' },
      5 => { symbol: '↘', description: 'Falling slightly' },
      6 => { symbol: '↓', description: 'Falling' },
      7 => { symbol: '↓↓', description: 'Falling quickly' },
      8 => { symbol: '?', description: 'Undetermined' },
      9 => { symbol: '-', description: 'Trend unavailable' }
    }.freeze

    attr_reader :timestamp, :trend, :value

    alias mg_dl value

    def initialize(value, trend, timestamp)
      @value = value
      @trend = trend
      @timestamp = timestamp
    end

    def mmol
      (mg_dl * MGDL_TO_MMOL_FACTOR).round(1)
    end

    def trend_symbol
      TRENDS.dig(trend, :symbol)
    end

    def trend_description
      TRENDS.dig(trend, :description)
    end
  end
end
