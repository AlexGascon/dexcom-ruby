# frozen_string_literal: true

RSpec.shared_examples 'retrieves blood glucose values' do |number_of_values|
  let(:base_url) { 'https://shareous1.dexcom.com/ShareWebServices/Services' }
  let(:blood_glucose_response_item) do
    [{
      'DT': '/Date(1591500198000+0000)/',
      'ST': '/Date(1591492998000)/',
      'Trend': 4,
      'Value': 96,
      'WT': '/Date(1591492998000)/'
    }]
  end
  let(:expected_response_body) { (blood_glucose_response_item * number_of_values).to_json }

  before do
    @blood_glucose_request =
      stub_request(:post, "#{base_url}/Publisher/ReadPublisherLatestGlucoseValues")
      .with(
        headers: { 'User-Agent' => 'Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0' },
        query: { minutes: 1440, maxCount: number_of_values }
      )
      .to_return(status: 200, body: expected_response_body)
  end

  it 'makes a request to the API' do
    subject

    expect(@blood_glucose_request).to have_been_made.times(1)
  end
end

RSpec.describe Dexcom::BloodGlucose do
  describe '.get_last' do
    context 'when is called without arguments' do
      subject { Dexcom::BloodGlucose.get_last }

      it_behaves_like 'retrieves blood glucose values', 1
    end

    context 'when is called with max_count' do
      max_count = 5
      subject { Dexcom::BloodGlucose.get_last(max_count: max_count) }

      it_behaves_like 'retrieves blood glucose values', max_count
    end

    context 'when is called with minutes' do
      minutes = 15
      subject { Dexcom::BloodGlucose.get_last(minutes: minutes) }

      it_behaves_like 'retrieves blood glucose values', (minutes / 5)
    end

    context 'when is called with a max_count and minutes' do
      minutes = 20
      max_count = 6
      subject { Dexcom::BloodGlucose.get_last(minutes: minutes, max_count: max_count) }

      it_behaves_like 'retrieves blood glucose values', [minutes / 5, max_count].min
    end
  end

  describe '.last' do
    subject { Dexcom::BloodGlucose.last }

    it_behaves_like 'retrieves blood glucose values', 1
  end
end
