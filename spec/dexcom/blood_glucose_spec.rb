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
    bg = result.last

    expect(bg.value).to eq 96
    expect(bg.trend).to eq 4
    expect(bg.timestamp).to eq DateTime.new(2020, 6, 10, 21, 43, 14, '+00:00')
  end
end

RSpec.describe Dexcom::BloodGlucose do
  MINUTES_BETWEEN_BGS = 5
  LAST_TIMESTAMP_WITH_DATA = DateTime.new(2020, 6, 10, 21, 43, 14, '+00:00')

  describe 'fields and properties' do
    subject(:bg) { build(:blood_glucose) }

    it('#mg_dl') { expect(bg.mg_dl).to eq 142 }
    it('#mmol') { expect(bg.mmol).to eq 7.9 }
    it('#timestamp') { expect(bg.timestamp).to eq LAST_TIMESTAMP_WITH_DATA }
    it('#trend_symbol') { expect(bg.trend_symbol).to eq '↗' }
    it('#trend_description') { expect(bg.trend_description).to eq 'Rising slightly' }
  end

  describe 'API methods' do
    let(:base_url) { 'https://shareous1.dexcom.com/ShareWebServices/Services' }
    let(:response_body) { Helpers.mock_api_bgs(LAST_TIMESTAMP_WITH_DATA, number_of_values).to_json }

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

    around do |example|
      Timecop.freeze LAST_TIMESTAMP_WITH_DATA

      example.run

      Timecop.return
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
        subject { Dexcom::BloodGlucose.get_last(minutes: 15) }

        it_behaves_like 'retrieves blood glucose values', (15 / MINUTES_BETWEEN_BGS)

        context 'when there is no data for part of the specified period' do
          it 'filters to return only the corresponding minutes' do
            delay_in_minutes = 8
            Timecop.freeze(LAST_TIMESTAMP_WITH_DATA + Helpers.minutes_to_datetime_delta(delay_in_minutes))

            result = subject

            minutes_with_data = 15 - delay_in_minutes
            expected_count = (minutes_with_data * 1.0 / MINUTES_BETWEEN_BGS).ceil
            expect(result.size).to eq expected_count

            Timecop.return
          end
        end

        context 'when the last allowed time exactly matches a reading timestamp' do
          it 'includes that reading' do
            delay_in_minutes = 15
            Timecop.freeze(LAST_TIMESTAMP_WITH_DATA + Helpers.minutes_to_datetime_delta(delay_in_minutes))

            result = subject
            expect(result.size).to eq 1

            Timecop.return
          end
        end

        context 'when there is no data for the specified period' do
          it 'returns an empty array if no datapoint was published in the specified period' do
            delay_in_years = 20
            delay_in_minutes = delay_in_years * 365 * 24 * 60
            Timecop.freeze LAST_TIMESTAMP_WITH_DATA + Helpers.minutes_to_datetime_delta(delay_in_minutes)

            result = subject
            expect(result).to eq []

            Timecop.return
          end
        end
      end

      context 'when is called with a max_count and minutes' do
        let(:number_of_values) { 4 }

        it 'returns the minimum number of BloodGlucose items' do
          result = Dexcom::BloodGlucose.get_last(minutes: 20, max_count: 6)

          expected_count = [20 / MINUTES_BETWEEN_BGS, 6].min
          expect(result.size).to eq expected_count
        end

        context 'when the minimum is driven by count but datapoints are outdated' do
          let(:number_of_values) { 3 }

          it 'returns only the datapoints in the specified period' do
            delay_in_minutes = 21
            Timecop.freeze LAST_TIMESTAMP_WITH_DATA + Helpers.minutes_to_datetime_delta(delay_in_minutes)

            result = Dexcom::BloodGlucose.get_last(minutes: 20, max_count: 3)
            expect(result).to eq []

            Timecop.return
          end
        end
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
