module Blueprint
  module Helpers
    extend ActiveSupport::Concern

    included do
      def find_blueprint_for(object)
        Blueprint.find_for(object)
      end
    end
  end
end