module Orderer
  module Helpers
    extend ActiveSupport::Concern

    included do
      def order(object, blueprint: nil, order_directions: nil)
        Orderer.order(object, blueprint: blueprint, order_directions: order_directions)
      end
    end
  end
end