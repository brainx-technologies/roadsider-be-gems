require "multiple_enum/version"

module MultipleEnum
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Core
    autoload :MultipleEnumType
  end

  ActiveSupport.on_load(:active_record) do
    include Core
  end
end
