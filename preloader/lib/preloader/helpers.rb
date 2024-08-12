module Preloader
  module Helpers
    extend ActiveSupport::Concern

    included do
      def preload(object, blueprint: nil, attribute_names: nil)
        Preloader.preload(object, blueprint: blueprint, attribute_names: attribute_names)
      end
    end
  end
end