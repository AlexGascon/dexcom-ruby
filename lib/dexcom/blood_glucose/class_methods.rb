# frozen_string_literal

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
        process_api_response(response)
      end

      private

      def calculate_number_of_values(max_count, minutes)
        if minutes.nil?
          max_count || DEFAULT_NUMBER_OF_VALUES
        elsif max_count.nil?
          minutes / MINUTES_PER_DATAPOINT
        else
          [max_count, minutes / MINUTES_PER_DATAPOINT].min
        end
      end
    end
  end
end
