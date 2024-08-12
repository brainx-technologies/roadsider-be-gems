require "blueprint/version"

module Blueprint
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Base
    autoload :Finding
    autoload :Attributing
    autoload :Attribute
    autoload :Helpers
  end

  include Finding
  include Attributing

  ActiveSupport.on_load(:action_controller) do
    include Helpers
  end
end
