module Paginator
  module Configuring
    extend ActiveSupport::Concern

    class_methods do
      def configuration
        @configuration ||= Configuration.new(25)
      end

      def configure
        yield configuration
      end
    end
  end
end