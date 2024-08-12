module Preloader
  module Core
    extend ActiveSupport::Concern

    class_methods do
      def preload(object, blueprint: nil, attribute_names: nil)
        if object.respond_to?(:all)
          blueprint ||= Blueprint.find_for(object)

          if blueprint.present?
            object = object.includes(includes_options(object, blueprint, attribute_names)).preload(preload_options(object, blueprint, attribute_names))
            object = merge_scopes(object, blueprint, attribute_names).reduce(object) { |a, b| a.merge(b) }
          end
        end

        object
      end

      private
      def includes_options(object, blueprint, attribute_names)
        options = []

        blueprint.attributes_for(attribute_names).each do |attribute|
          reflection = object.reflect_on_association(attribute.name)
          if reflection.nil? && attribute.name.to_s.end_with?('_ids')
            reflection = object.reflect_on_association(attribute.name.to_s.gsub(/_ids$/, '').pluralize)
          end

          if reflection.present? && !reflection.polymorphic?
            if attribute.name == reflection.name
              nested_blueprint = attribute.blueprint || Blueprint.find_for(reflection.klass)
              nested_includes_options = includes_options(reflection.klass, nested_blueprint, Blueprint.attribute_names_for(attribute, attribute_names)) if nested_blueprint.present?
            end

            if nested_includes_options.present?
              options.delete(reflection.name) if options.include?(reflection.name)
              options << { reflection.name => nested_includes_options }
            elsif options.exclude?(reflection.name) && options.select { |o| o.is_a?(Hash) }.none? { |o| o.include?(reflection.name) }
              options << reflection.name
            end
          end
        end

        options
      end

      def preload_options(object, blueprint, attribute_names)
        options = []

        blueprint.attributes_for(attribute_names).each do |attribute|
          options << attribute.name if options.exclude?(attribute.name) && object.reflect_on_association(attribute.name)&.polymorphic?
        end

        options
      end

      def merge_scopes(object, blueprint, attribute_names)
        scopes = []

        blueprint.attributes_for(attribute_names).each do |attribute|
          if attribute.preloader.respond_to?(:call)
            scopes << attribute.preloader.call(object)
          elsif attribute.preloader.is_a?(Symbol) || attribute.preloader.is_a?(String)
            scopes << blueprint.instance.public_send(attribute.preloader, object)
          else
            reflection = object.reflect_on_association(attribute.name)
            if reflection.nil? && attribute.name.to_s.end_with?('_ids')
              reflection = object.reflect_on_association(attribute.name.to_s.gsub(/_ids$/, '').pluralize)
            end

            if reflection.present? && !reflection.polymorphic?
              if attribute.name == reflection.name
                nested_blueprint = attribute.blueprint || Blueprint.find_for(reflection.klass)
                nested_scopes = merge_scopes(reflection.klass, nested_blueprint, Blueprint.attribute_names_for(attribute, attribute_names)) if nested_blueprint.present?
              end

              scopes.push(*nested_scopes) if nested_scopes.present?
            end
          end
        end

        scopes
      end
    end
  end
end