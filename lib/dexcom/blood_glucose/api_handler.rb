# frozen_string_literal: true

require 'utils/httparty_configured'

module Dexcom
  module BloodGlucoseUtils
    module ApiHandler
      include ::Utils::HTTPartyConfigured

      MAX_MINUTES = 1440

      def make_api_request(number_of_values)
        HTTParty.post(
          endpoint,
          headers: headers,
          query: query(number_of_values)
        )
      end

      def process_api_response(response)
        response_body = JSON.parse(response.body)

        response_body.map { |blood_glucose_item| build_from_api_response(blood_glucose_item) }
      end

      def build_from_api_response(blood_glucose_response_item)
        Dexcom::BloodGlucose.new(
          blood_glucose_response_item['Value'],
          blood_glucose_response_item['Trend'],
          parse_timestamp(blood_glucose_response_item)
        )
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
          minutes: MAX_MINUTES,
          sessionId: Dexcom::Authentication.session_id
        }
      end

      def parse_timestamp(blood_glucose_response_item)
        timestamp_info = blood_glucose_response_item['WT']
        timestamp_regex = /(\d+)000/
        timestamp = timestamp_info[timestamp_regex, 1]

        DateTime.strptime(timestamp, '%s')
      end

      def config
        @config ||= Dexcom.configuration
      end
    end
  end
end
