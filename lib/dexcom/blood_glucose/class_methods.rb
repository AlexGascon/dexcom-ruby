# frozen_string_literal

require 'active_support'
require 'active_support/core_ext'

module Dexcom
  module BloodGlucoseUtils
    module ClassMethods
      DEFAULT_NUMBER_OF_VALUES = 1
      MINUTES_PER_DATAPOINT = 5

      def last
        get_last(max_count: 1).first
      end

      def get_last(max_count: nil, minutes: nil)
        number_of_values = calculate_number_of_values(max_count, minutes)

        response = make_api_request(number_of_values)
        blood_glucose_values = process_api_response(response)

        if minutes.present?
          blood_glucose_values.select! { |bg| bg.timestamp >= minutes.minutes.ago }
        end

        blood_glucose_values
      end

      private

      def calculate_number_of_values(max_count, minutes)
        return DEFAULT_NUMBER_OF_VALUES if (minutes.nil? && max_count.nil?)
        return max_count if minutes.nil?
        return (minutes / MINUTES_PER_DATAPOINT) if max_count.nil?

        [max_count, minutes / MINUTES_PER_DATAPOINT].min
      end
    end
  end
end
