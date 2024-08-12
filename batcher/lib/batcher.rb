require "batcher/version"
require "batcher/railtie" if defined?(::Rails)

module Batcher
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Middleware
    autoload :Executor
    autoload :Request
    autoload :Response
    autoload :Configuration
    autoload :Configuring
  end

  include Configuring
end
