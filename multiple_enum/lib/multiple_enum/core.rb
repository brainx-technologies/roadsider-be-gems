module MultipleEnum
  module Core
    extend ActiveSupport::Concern

    included do
      class_attribute :defined_multiple_enums, instance_accessor: false
    end

    class_methods do
      def multiple_enum(name = nil, values = nil, **options)
        if name.present?
          values, options = options, {} unless values
          return _multiple_enum(name, values, **options)
        end

        definitions = options.slice!(:_prefix, :_suffix, :_scopes, :_default)
        options.transform_keys! { |key| :"#{key[1..-1]}" }

        definitions.each { |name, values| _multiple_enum(name, values, **options) }
      end

      private
      def _multiple_enum(name, values, prefix: nil, suffix: nil, scopes: true, **options)
        send(:assert_valid_enum_definition_values, values)
        enum_values = ActiveSupport::HashWithIndifferentAccess.new
        name = name.to_s

        send(:detect_enum_conflict!, name, name.pluralize, true)
        singleton_class.define_method(name.pluralize) { enum_values }
        self.defined_multiple_enums ||= {}
        self.defined_multiple_enums[name] = enum_values

        send(:detect_enum_conflict!, name, name)
        send(:detect_enum_conflict!, name, "#{name}=")

        if ActiveRecord.version >= Gem::Version.new('7.0.0')
          attr = name

          attribute(name, **options) do |subtype|
            subtype = subtype.subtype if MultipleEnumType === subtype
            MultipleEnumType.new(name, enum_values, subtype)
          end
        end

        prefix = prefix == true ? "#{name}_" : "#{prefix}_" if prefix.present?

        suffix = suffix == true ? "_#{name}" : "_#{suffix}" if suffix.present?

        if scopes != false
          send(:detect_enum_conflict!, name, "with_#{prefix}#{name}#{suffix}", true)
          singleton_class.define_method("with_#{prefix}#{name}#{suffix}") do |*values|
            values = values&.flatten&.map(&:to_s)
            if (values & enum_values.keys).any?
              where(Arel::Nodes::InfixOperation.new('@>', arel_table[name], Arel::Nodes::SqlLiteral.new("ARRAY#{enum_values.slice(*values).values}")))
            else
              none
            end
          end

          send(:detect_enum_conflict!, name, "without_#{prefix}#{name}#{suffix}", true)
          singleton_class.define_method("without_#{prefix}#{name}#{suffix}") do |*values|
            values = values&.flatten&.map(&:to_s)
            if (values & enum_values.keys).any?
              where.not(Arel::Nodes::InfixOperation.new('@>', arel_table[name], Arel::Nodes::SqlLiteral.new("ARRAY#{enum_values.slice(*values).values}")))
            else
              all
            end
          end
        end

        if ActiveRecord.version < Gem::Version.new('7.0.0')
          attr = attribute_alias?(name) ? attribute_alias(name) : name
          if ActiveRecord.version >= Gem::Version.new('6.1.0.alpha')
            decorate_attribute_type(attr) do |subtype|
              MultipleEnumType.new(attr, enum_values, subtype)
            end
          else
            decorate_attribute_type(attr, :multiple_enum) do |subtype|
              MultipleEnumType.new(attr, enum_values, subtype)
            end
          end
        end

        value_method_names = []
        pairs = values.respond_to?(:each_pair) ? values.each_pair : values.each_with_index
        pairs.each do |label, value|
          value_method_name = "#{prefix}#{label}#{suffix}"
          value_method_names << value_method_name

          enum_values[label] = value
          label = label.to_s

          send(:detect_enum_conflict!, name, "#{value_method_name}?")
          define_method("#{value_method_name}?") { self[attr]&.include?(label) }

          if scopes != false
            send(:detect_negative_condition!, value_method_name) if ActiveRecord.version < Gem::Version.new('6.0.4')

            send(:detect_enum_conflict!, name, value_method_name, true)
            scope value_method_name, -> { send("with_#{prefix}#{name}#{suffix}", label) }

            send(:detect_enum_conflict!, name, "not_#{value_method_name}", true)
            scope "not_#{value_method_name}", -> { send("without_#{prefix}#{name}#{suffix}", label) }
          end
        end
        send(:detect_negative_enum_conditions!, value_method_names) if ActiveRecord.version >= Gem::Version.new('6.0.4') && scopes != false
      end
    end
  end
end