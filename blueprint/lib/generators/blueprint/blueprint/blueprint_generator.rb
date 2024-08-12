module Blueprint
  module Generators
    class BlueprintGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_blueprint
        template 'blueprint.rb.erb', File.join('app', 'blueprints', "#{file_name}_blueprint.rb")
      end
    end
  end
end