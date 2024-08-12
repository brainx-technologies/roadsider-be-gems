module Paginator
  module Helpers
    extend ActiveSupport::Concern

    included do
      def paginate(object, limit: nil, offset: nil)
        Paginator.paginate(object, limit: limit, offset: offset)
      end

      def pagination(object, root: true)
        Paginator.pagination(object, root: root)
      end
    end
  end
end