# frozen_string_literal: true

module Dexcom
  class BloodGlucose
    DEFAULT_NUMBER_OF_VALUES = 1
    MAX_MINUTES = 1440
    MINUTES_PER_DATAPOINT = 5

    class << self
      def last
        get_last(max_count: 1)
      end

      def get_last(max_count: nil, minutes: nil)
        number_of_values =
          if minutes.nil?
            max_count || DEFAULT_NUMBER_OF_VALUES
          elsif max_count.nil?
            minutes / MINUTES_PER_DATAPOINT
          else
            [max_count, minutes / MINUTES_PER_DATAPOINT].min
          end

        response = HTTParty.post(
          endpoint,
          headers: headers,
          query: query(number_of_values)
        ).to_json
      end

      private

      def endpoint
        "#{config.base_url}/Publisher/ReadPublisherLatestGlucoseValues"
      end

      def headers
        {
          'User-Agent' => USER_AGENT
        }
      end

      def query(max_count)
        {
          maxCount: max_count,
          minutes: MAX_MINUTES
        }
      end

      def config
        @config ||= Dexcom.configuration
      end
    end
  end
end
