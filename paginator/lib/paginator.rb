require "paginator/version"

module Paginator
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Core
    autoload :Helpers
    autoload :Configuration
    autoload :Configuring
  end

  include Core
  include Configuring

  ActiveSupport.on_load(:action_controller) do
    include Helpers
  end
end
