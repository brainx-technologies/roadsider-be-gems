require "blueprint/version"

module Serializer
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Core
    autoload :Helpers
  end

  include Core

  ActiveSupport.on_load(:action_controller) do
    include Helpers
  end
end
