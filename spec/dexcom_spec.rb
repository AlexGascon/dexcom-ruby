# frozen_string_literal: true

RSpec.describe Dexcom do
  it 'has a version number' do
    expect(Dexcom::VERSION).not_to be_nil
  end

  describe '.configure' do
    it 'sets the class configuration' do
      username = 'username'
      password = 'password'
      outside_usa = true

      described_class.configure do |config|
        config.username = username
        config.password = password
        config.outside_usa = outside_usa
      end

      configuration = described_class.configuration
      expect(configuration.username).to eq username
      expect(configuration.password).to eq password
      expect(configuration.outside_usa).to eq outside_usa
    end
  end
end