# frozen_string_literal: true

require 'httparty'
require 'dexcom/utils'

module Dexcom
  class Authentication
    class << self
      def access_token
        refresh_access_token if @access_token.nil?

        @access_token
      end

      def session_id
        refresh_access_token unless auth_started?
        refresh_session_id if @session_id.nil?

        @session_id
      end

      def renew_authentication
        @access_token = nil
        @session_id = nil

        refresh_access_token
        refresh_session_id
      end

      private

      def auth_started?
        !@access_token.nil?
      end

      def refresh_access_token
        response = authenticate
        @access_token = remove_double_quotes(response)
      end

      def refresh_session_id
        response = login
        @session_id = remove_double_quotes(response)
      end

      def config
        @config ||= Dexcom.configuration
      end

      def authenticate
        HTTParty.post(
          authenticate_endpoint,
          headers: credentials_headers,
          body: credentials_payload.to_json
        )
      end

      def authenticate_endpoint
        "#{config.base_url}/General/AuthenticatePublisherAccount"
      end

      def login
        HTTParty.post(
          login_endpoint,
          headers: credentials_headers,
          body: credentials_payload.to_json
        )
      end

      def login_endpoint
        "#{config.base_url}/General/LoginPublisherAccountByName"
      end

      def credentials_headers
        {
          'User-Agent' => USER_AGENT,
          'Content-Type' => 'application/json'
        }
      end

      def credentials_payload
        {
          accountName: config.username,
          password: config.password,
          applicationId: APPLICATION_ID
        }
      end

      def remove_double_quotes(text)
        text.gsub('"', '')
      end
    end
  end
end
