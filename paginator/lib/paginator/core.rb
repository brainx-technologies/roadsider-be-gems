module Paginator
  module Core
    extend ActiveSupport::Concern

    class_methods do
      def paginate(object, limit: nil, offset: nil)
        if object.respond_to?(:all)
          limit = [limit&.abs, Paginator.configuration.limit].compact.min
          offset = [offset&.abs, 0].compact.max

          object = object.limit(limit).offset(offset)
        end

        object
      end

      def pagination(object, root: true)
        if object.respond_to?(:all)
          pagination = {
              limit: object.limit_value,
              offset: object.offset_value,
              count: object.count,
              total_count: object.unscope(:limit, :offset).count
          }

          if root.present?
            if root === true
              root = :pagination
            end

            if root.is_a?(Symbol) || root.is_a?(String)
              pagination = { root.to_sym => pagination }
            end
          end

          pagination
        else
          nil
        end
      end
    end
  end
end