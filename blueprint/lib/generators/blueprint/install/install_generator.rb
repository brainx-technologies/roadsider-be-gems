module Blueprint
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_application_blueprint
        template 'application_blueprint.rb', File.join('app', 'blueprints', 'application_blueprint.rb')
      end
    end
  end
end