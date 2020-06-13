lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dexcom/version'

Gem::Specification.new do |spec|
  spec.name           = 'dexcom'
  spec.version        = Dexcom::VERSION
  spec.summary        = 'Gem to interact with Dexcom Share API'
  spec.authors        = ['Alex Gascon']
  spec.email          = 'alexgascon.93@gmail.com'
  spec.license        = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files          = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir         = 'exe'
  spec.executables    = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths  = ['lib']

  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'climate_control'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
