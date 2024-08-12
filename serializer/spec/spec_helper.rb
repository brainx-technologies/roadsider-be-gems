require 'bundler/setup'
require 'active_record'
require 'factory_bot'
require 'faker'
require 'blueprint'
require 'serializer'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

Dir[File.join(__dir__, 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true

  config.include FactoryBot::Syntax::Methods
end
