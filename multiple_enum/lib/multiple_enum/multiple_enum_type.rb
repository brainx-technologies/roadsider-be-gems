module MultipleEnum
  class MultipleEnumType < ActiveRecord::Type::Value
    attr_reader :subtype

    delegate :type, to: :subtype

    def initialize(name, mapping, subtype)
      @name = name
      @mapping = mapping
      @subtype = subtype
    end

    def cast(value)
      return if value.blank?

      value.map do |value|
        if mapping.has_key?(value)
          value.to_s
        elsif mapping.has_value?(value)
          mapping.key(value)
        else
          assert_valid_value([value])
        end
      end
    end

    def deserialize(value)
      return if value.nil?

      subtype.deserialize(value).map do |value|
        mapping.key(value)
      end
    end

    def serialize(value)
      value = (value || []).map do |value|
        mapping.fetch(value, value)
      end
      subtype.serialize(value)
    end

    def assert_valid_value(value)
      return if value.blank?

      value.each do |value|
        raise ArgumentError, "'#{value}' is not a valid #{name}" unless value.blank? || mapping.has_key?(value) || mapping.has_value?(value)
      end
    end

    private
    attr_reader :name
    attr_reader :mapping
  end
end