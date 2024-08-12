module Blueprint
  module Attributing
    extend ActiveSupport::Concern

    class_methods do
      def attribute_names_for(attribute, attribute_names)
        attribute_names ||= []
        attribute_names = attribute_names.select { |a| a.is_a?(Hash) }
        attribute_names = attribute_names.reduce({}) { |a, b| a.merge(b) }
        attribute_names = attribute_names.transform_keys(&:to_sym)
        attribute_names[attribute.name]
      end
    end
  end
end
