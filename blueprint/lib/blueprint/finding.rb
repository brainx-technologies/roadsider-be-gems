module Blueprint
  module Finding
    extend ActiveSupport::Concern

    class_methods do
      def find_for(object)
        if object.is_a?(Class)
          object_name = object.name
        elsif object.respond_to?(:klass)
          object_name = object.klass&.name
        elsif object.present?
          object_name = object.class.name
        else
          return nil
        end

        blueprint = nil

        loop do
          blueprint = "#{object_name}#{Blueprint.name}".safe_constantize
          break if blueprint.present?

          if i = object_name.index('::')
            object_name = object_name[(i + 2)..-1]
          else
            break
          end
        end

        blueprint
      end
    end
  end
end