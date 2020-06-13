# frozen_string_literal: true

RSpec.shared_examples 'retrieves blood glucose values' do |number_of_values|
  it 'makes a request to the API' do
    subject

    expect(@blood_glucose_request).to have_been_made.times(1)
  end

  it 'returns the correct number of BloodGlucose items' do
    result = subject

    expect(result.size).to eq number_of_values
  end

  it 'correctly parses the BloodGlucose data' do
    result = subject
    bg = result.first

    expect(bg.value).to eq 96
    expect(bg.trend).to eq 4
    expect(bg.timestamp).to eq DateTime.new(2020, 6, 10, 21, 43, 14, '+00:00')
  end
end

RSpec.describe Dexcom::BloodGlucose do

  describe 'fields and properties' do
    subject(:bg) { build(:blood_glucose) }

    it('#mg_dl') { expect(bg.mg_dl).to eq 142 }
    it('#mmol') { expect(bg.mmol).to eq 7.9 }
    it('#timestamp') { expect(bg.timestamp).to eq DateTime.new(2020, 6, 10, 21, 43, 14, '+00:00') }
    it('#trend_symbol') { expect(bg.trend_symbol).to eq '↗' }
    it('#trend_description') { expect(bg.trend_description).to eq 'Rising slightly' }
  end

  describe 'API methods' do
    let(:base_url) { 'https://shareous1.dexcom.com/ShareWebServices/Services' }
    let(:blood_glucose_response_item) do
      [{
        'DT': '/Date(1591832594000+0000)/',
        'ST': '/Date(1591825394000)/',
        'Trend': 4,
        'Value': 96,
        'WT': '/Date(1591825394000)/'
      }]
    end
    let(:response_body) { (blood_glucose_response_item * number_of_values).to_json }

    before do
      allow(Dexcom::Authentication).to receive(:session_id).and_return '1234-56-7890'

      @blood_glucose_request =
        stub_request(:post, "#{base_url}/Publisher/ReadPublisherLatestGlucoseValues")
        .with(
          headers: { 'User-Agent' => 'Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0' },
          query: { minutes: 1440, maxCount: number_of_values, sessionId: '1234-56-7890' }
        )
        .to_return(status: 200, body: response_body)
    end

    describe '.get_last' do
      context 'when is called without arguments' do
        let(:number_of_values) { 1 }
        subject { Dexcom::BloodGlucose.get_last }

        it_behaves_like 'retrieves blood glucose values', 1
      end

      context 'when is called with max_count' do
        let(:number_of_values) { 5 }

        subject { Dexcom::BloodGlucose.get_last(max_count: number_of_values) }

        it_behaves_like 'retrieves blood glucose values', 5
      end

      context 'when is called with minutes' do
        let(:number_of_values) { 3 }
        minutes = 15
        subject { Dexcom::BloodGlucose.get_last(minutes: minutes) }

        it_behaves_like 'retrieves blood glucose values', (minutes / 5)
      end

      context 'when is called with a max_count and minutes' do
        let(:number_of_values) { 4 }
        minutes = 20
        max_count = 6
        subject { Dexcom::BloodGlucose.get_last(minutes: minutes, max_count: max_count) }

        it_behaves_like 'retrieves blood glucose values', [minutes / 5, max_count].min
      end
    end

    describe '.last' do
      let(:number_of_values) { 1 }

      subject { Dexcom::BloodGlucose.last }

      it 'makes a request to the API' do
        subject

        expect(@blood_glucose_request).to have_been_made.times(1)
      end

      it 'returns a Dexcom::BloodGlucose element' do
        expect(subject).to be_a_kind_of(Dexcom::BloodGlucose)
      end

      it 'correctly parses the BloodGlucose data' do
        bg = subject

        expect(bg.value).to eq 96
        expect(bg.trend).to eq 4
        expect(bg.timestamp).to eq DateTime.new(2020, 6, 10, 21, 43, 14, '+00:00')
      end
    end
  end
end
