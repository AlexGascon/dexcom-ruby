# frozen_string_literal: true

RSpec.describe Dexcom::Authentication do
  let(:base_url) { 'https://shareous1.dexcom.com/ShareWebServices/Services' }
  let(:user_agent) { 'Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0' }
  let(:application_id) { 'd89443d2-327c-4a6f-89e5-496bbb0317db' }
  let(:account_name) { 'dexcom_username' }
  let(:password) { 'dexcom_password' }
  let(:num_values) { 1 }
  let(:session_id) { 'random-session-id'}

  before do
    headers = { 'User-Agent' => user_agent , 'Content-Type' => 'application/json' }
    payload = { accountName: account_name, password: password, applicationId: application_id }
    query = { 'sessionId': session_id, minutes: 1440, maxCount: num_values }

    @auth_request =
      stub_request(:post, "#{base_url}/General/AuthenticatePublisherAccount")
      .with(headers: headers, body: payload)

    @login_request =
      stub_request(:post, "#{base_url}/General/LoginPublisherAccountByName")
      .with(headers: headers, body: payload)
    end

  describe '.access_token' do
    before do
      @auth_request.to_return(status: 200, body: '"random-auth-id"')
    end

    it 'returns the auth token' do
      expect(Dexcom::Authentication.access_token).to eq 'random-auth-id'
    end

    context 'when the access token is not set' do
      before do
        Dexcom::Authentication.instance_variable_set('@access_token', nil)
      end

      it 'makes an auth request' do
        Dexcom::Authentication.access_token

        expect(@auth_request).to have_been_made.times(1)
      end
    end
  end

  describe '.session_id' do
    before do
      @auth_request.to_return(status: 200, body: '"random-auth-id"')
      @login_request.to_return(status: 200, body: '"random-session-id"')
    end

    it 'returns the session ID' do
      expect(Dexcom::Authentication.session_id).to eq 'random-session-id'
    end

    context 'when the session_id is not set' do
      before do
        Dexcom::Authentication.instance_variable_set('@session_id', nil)
      end

      it 'makes a login request' do
        Dexcom::Authentication.session_id

        expect(@login_request).to have_been_made.times(1)
      end
    end

    context 'when the access_token is not set' do
      before do
        Dexcom::Authentication.instance_variable_set('@access_token', nil)
      end

      it 'makes an auth request' do
        Dexcom::Authentication.access_token

        expect(@auth_request).to have_been_made.times(1)
      end
    end
  end
end
