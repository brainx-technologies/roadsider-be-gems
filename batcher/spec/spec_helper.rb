require 'bundler/setup'
require 'json'
require 'rack'
require 'active_support/all'
require 'batcher'

Dir[File.join(__dir__, 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true
end
