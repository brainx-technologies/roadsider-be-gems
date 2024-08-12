module Orderer
  module Core
    extend ActiveSupport::Concern

    class_methods do
      def order(object, blueprint: nil, order_directions: nil)
        if object.respond_to?(:all)
          blueprint ||= Blueprint.find_for(object)
          order_directions = { id: :asc } if order_directions.blank?

          object = object.left_joins(joins_options(object, blueprint, order_directions)).order(order_options(object, blueprint, order_directions)) if blueprint.present?
        end

        object
      end

      private
      def joins_options(object, blueprint, order_directions)
        return [] if order_directions.blank?

        options = []

        order_directions.keys.each do |attribute_name|
          attribute = blueprint.attribute_for(attribute_name)
          next if attribute.blank?

          reflection = object.reflect_on_association(attribute.name)
          if reflection.present? && !reflection.polymorphic?
            nested_blueprint = attribute.blueprint || Blueprint.find_for(reflection.klass)
            nested_joins_options = joins_options(reflection.klass, nested_blueprint, order_directions[attribute.name]) if nested_blueprint.present?

            if nested_joins_options.present?
              options.delete(reflection.name) if options.include?(reflection.name)
              options << { reflection.name => nested_joins_options }
            elsif options.exclude?(reflection.name) && options.select { |o| o.is_a?(Hash) }.none? { |o| o.include?(reflection.name) }
              options << reflection.name
            end
          end
        end

        options
      end

      def order_options(object, blueprint, order_directions)
        return [] if order_directions.blank?

        options = []

        order_directions.keys.each do |attribute_name|
          attribute = blueprint.attribute_for(attribute_name)
          next if attribute.blank?

          reflection = object.reflect_on_association(attribute.name)
          if reflection.present? && !reflection.polymorphic?
            nested_blueprint = attribute.blueprint || Blueprint.find_for(reflection.klass)
            order_directions_options = order_options(reflection.klass, nested_blueprint, order_directions[attribute.name]) if nested_blueprint.present?
            options += order_directions_options
          elsif reflection.nil?
            order_directions_arel_attribute = object.arel_table[attribute.name]
            direction = order_directions[attribute.name]&.to_sym
            if direction == :desc
              options << order_directions_arel_attribute.desc
            elsif direction == :asc
              options << order_directions_arel_attribute.asc
            end
          end
        end

        options
      end
    end
  end
end