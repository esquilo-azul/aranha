# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)
require 'tmpdir'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ::File.join(::Dir.tmpdir, 'aranha_rspec')

  require 'eac_ruby_gem_support/rspec'
  ::EacRubyGemSupport::Rspec.setup(::File.expand_path('..', __dir__), config)
end
