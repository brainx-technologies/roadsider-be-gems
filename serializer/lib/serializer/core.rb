module Serializer
  module Core
    extend ActiveSupport::Concern

    class_methods do
      def serialize(object, root: true, blueprint: nil, attribute_names: nil, **options)
        if enumerable?(object)
          result = object.map { |o| serialize(o, root: false, blueprint: blueprint, attribute_names: attribute_names, **options) }
        else
          blueprint = Blueprint.find_for(object) if blueprint.blank? && blueprintable?(object)
          if blueprint.present?
            result = {}

            blueprint.attributes_for(attribute_names).each do |attribute|
              attribute_options = options_for(object, blueprint: blueprint, options: options, optionsable: attribute.options)

              next if skip?(object, blueprint: blueprint, attribute: attribute, options: attribute_options)

              result[attribute.name] = extract(object, blueprint: blueprint, attribute: attribute, options: attribute_options, attribute_names: attribute_names)
            end
          else
            result = object
          end
        end

        if root.present?
          if root === true
            root = name_for(object)&.underscore
            root = root.pluralize if root.present? && enumerable?(object)
          end

          if root.is_a?(Symbol) || root.is_a?(String)
            result = { root.to_sym => result }
          end
        end

        result
      end

      private
      def blueprintable?(object)
        object.is_a?(ActiveRecord::Base) || object.is_a?(ActiveModel::Model)
      end

      def enumerable?(object)
        object.is_a?(Enumerable) && !object.is_a?(Hash)
      end

      def skip?(object, blueprint:, attribute:, options:)
        if attribute.if.present?
          !call_in(blueprint, attribute.if, object, options)
        elsif attribute.unless.present?
          call_in(blueprint, attribute.unless, object, options)
        else
          false
        end
      end

      def extract(object, blueprint:, attribute:, options:, attribute_names:)
        if attribute.reader.present?
          value = call_in(blueprint, attribute.reader, object, options)
        elsif object.is_a?(Hash)
          value = object[attribute.name]
        else
          value = object.public_send(attribute.name)
        end

        serialize(value, root: false, blueprint: attribute.blueprint, attribute_names: Blueprint.attribute_names_for(attribute, attribute_names), **options)
      end

      def name_for(object)
        if object.respond_to?(:ancestors)
          object.name
        elsif object.present?
          object.class.name
        else
          nil
        end
      end

      def options_for(object, blueprint:, options:, optionsable:)
        if optionsable.present?
          optionsable = call_in(blueprint, optionsable, object, options&.dup) unless optionsable.is_a?(Hash)

          return (options || {}).merge(optionsable) if optionsable.present?
        end

        options&.dup
      end

      def call_in(blueprint, callable, *arguments)
        case callable
        when Symbol
          arity = [blueprint.instance.public_method(callable).arity, -1].max.abs
          blueprint.instance.public_send(callable, *arguments.take(arity))
        when Proc
          arity = [callable.arity, -1].max.abs
          callable.call(*arguments.take(arity))
        else
          nil
        end
      end
    end
  end
end