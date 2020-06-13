require 'bundler/setup'
require 'pry'
require 'webmock/rspec'

require 'dexcom'
require_relative 'support/helpers'

Bundler.require(:default, :development)

Dexcom.configure do |config|
  config.username = 'dexcom_username'
  config.password = 'dexcom_password'
  config.outside_usa = true
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # FactoryBot configuration
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
