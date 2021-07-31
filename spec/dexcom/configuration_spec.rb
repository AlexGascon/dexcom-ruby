# frozen_string_literal: true

RSpec.describe Dexcom::Configuration do
  let(:config) { Dexcom.configuration }

  # We don't want to share configuration between specs
  before { Dexcom.configuration = Dexcom::Configuration.new }

  it 'adds the Dexcom.configure method' do
    expect(Dexcom).to respond_to(:configure)
  end

  it 'adds the Dexcom.configuration method' do
    expect(Dexcom).to respond_to(:configuration)
  end

  describe 'Dexcom.configuration' do
    it 'allows to provide a configuration directly' do
      new_config = Dexcom::Configuration.new
      new_config.username = 'new_username'

      Dexcom.configuration = new_config

      expect(Dexcom.configuration.username).to eq 'new_username'
    end

    it 'raises an error if the configuration is invalid' do
      expect { Dexcom.configuration = nil }.to raise_error StandardError
    end
  end

  describe 'Dexcom.configure' do
    it 'sets username' do
      Dexcom.configure do |c|
        c.username = 'username'
      end

      expect(config.username).to eq 'username'
    end

    it 'sets password' do
      Dexcom.configure do |c|
        c.password = 'password'
      end

      expect(config.password).to eq 'password'
    end

    it 'sets outside_usa' do
      Dexcom.configure do |c|
        c.outside_usa = false
      end

      expect(config.outside_usa).to eq false
    end

    it 'sets logger' do
      logger = OpenStruct.new

      Dexcom.configure do |c|
        c.logger = logger
      end

      expect(config.logger).to eq logger
    end

    it 'sets log_level' do
      Dexcom.configure do |c|
        c.log_level = :debug
      end

      expect(config.log_level).to eq :debug
    end
  end

  context 'default values' do
    it 'logger is nil' do
      expect(config.logger).to be_nil
    end

    it 'log_level is :info' do
      expect(config.log_level).to eq :info
    end
  end
end
