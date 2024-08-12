module Serializer
  module Helpers
    extend ActiveSupport::Concern

    included do
      def serialize(object, root: true, blueprint: nil, attribute_names: nil, **options)
        Serializer.serialize(object, root: root, blueprint: blueprint, attribute_names: attribute_names, **options)
      end
    end
  end
end