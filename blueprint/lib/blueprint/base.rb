module Blueprint
  class Base
    class_attribute :attributes, instance_accessor: false

    def self.inherited(klass)
      klass.include Singleton
    end

    def self.attribute(name, **options)
      validate_options(options)

      options[:name] = name.to_sym
      options[:optional] = false if options[:optional].blank?

      self.attributes ||= []
      self.attributes << Attribute.new(*options.values_at(*Attribute.members))
    end

    def self.attributes_for(attribute_names)
      attribute_names = (attribute_names || []).map { |a| a.is_a?(Hash) ? a.keys : a }
      attribute_names = attribute_names.flatten
      attribute_names = attribute_names.select { |a| a.is_a?(Symbol) || a.is_a?(String) }
      attribute_names = attribute_names.map(&:to_sym).uniq

      if attribute_names.empty?
        attributes.reject(&:optional)
      else
        attributes.select { |a| attribute_names.include?(a.name) }
      end
    end

    def self.attribute_for(attribute_name)
      attribute_name = attribute_name.to_sym

      attributes.find { |a| a.name == attribute_name }
    end

    private
    def self.validate_options(options)
      options.assert_valid_keys(options_valid_keys)
    end

    def self.options_valid_keys
      Attribute.members - [:name]
    end
  end
end