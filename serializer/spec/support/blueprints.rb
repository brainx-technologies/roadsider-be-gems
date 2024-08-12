class ApplicationBlueprint < Blueprint::Base
end

class HashBlueprint < ApplicationBlueprint
  attribute :a
  attribute :b
  attribute :c, optional: true
end

class SecondHashBlueprint < ApplicationBlueprint
  attribute :a
  attribute :b, blueprint: HashBlueprint
  attribute :c
end

class RecordBlueprint < ApplicationBlueprint
  attribute :id
  attribute :polymorphicable, optional: true
  attribute :polymorphicable_id, optional: true
  attribute :has_one_record, optional: true
  attribute :has_many_records, optional: true
  attribute :has_many_record_ids, optional: true
  attribute :has_and_belongs_to_many_records, optional: true
  attribute :integer_column
  attribute :float_column
  attribute :boolean_column
  attribute :string_column
  attribute :datetime_column
  attribute :integer_method
  attribute :record_method, optional: true
  attribute :blueprint_inline_reader, optional: true, reader: -> { 1 }
  attribute :blueprint_inline_reader_with_object, optional: true, reader: -> (object) { object.has_one_record }
  attribute :blueprint_inline_reader_with_object_and_options, optional: true, reader: -> (object, options) { object.has_one_record if options[:option] }
  attribute :blueprint_method_reader, optional: true, reader: :blueprint_method_reader
  attribute :blueprint_method_reader_with_object, optional: true, reader: :blueprint_method_reader_with_object
  attribute :blueprint_method_reader_with_object_and_options, optional: true, reader: :blueprint_method_reader_with_options
  attribute :blueprint_inline_if, optional: true, reader: -> (object) { object.has_one_record }, if: -> { true }
  attribute :blueprint_inline_if_with_object, optional: true, reader: -> (object) { object.has_one_record }, if: -> (object) { object.boolean_column }
  attribute :blueprint_inline_if_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, if: -> (object, options) { object.boolean_column && options[:option] }
  attribute :blueprint_method_if, optional: true, reader: -> (object) { object.has_one_record }, if: :blueprint_method_if
  attribute :blueprint_method_if_with_object, optional: true, reader: -> (object) { object.has_one_record }, if: :blueprint_method_if_with_object
  attribute :blueprint_method_if_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, if: :blueprint_method_if_with_object_and_options
  attribute :blueprint_inline_unless, optional: true, reader: -> (object) { object.has_one_record }, unless: -> { true }
  attribute :blueprint_inline_unless_with_object, optional: true, reader: -> (object) { object.has_one_record }, unless: -> (object) { object.boolean_column }
  attribute :blueprint_inline_unless_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, unless: -> (object, options) { object.boolean_column && options[:option] }
  attribute :blueprint_method_unless, optional: true, reader: -> (object) { object.has_one_record }, unless: :blueprint_method_unless
  attribute :blueprint_method_unless_with_object, optional: true, reader: -> (object) { object.has_one_record }, unless: :blueprint_method_unless_with_object
  attribute :blueprint_method_unless_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, unless: :blueprint_method_unless_with_object_and_options
  attribute :blueprint_inline_options, optional: true, reader: -> (object) { object.has_one_record }, options: -> { { nested_option: true } }
  attribute :blueprint_inline_hash_options, optional: true, reader: -> (object) { object.has_one_record }, options: { nested_option: true }
  attribute :blueprint_inline_options_with_object, optional: true, reader: -> (object) { object.has_one_record }, options: -> (object) { { nested_option: object.boolean_column } }
  attribute :blueprint_inline_options_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, options: -> (object, options) { { nested_option: object.boolean_column && options[:option] } }
  attribute :blueprint_method_options, optional: true, reader: -> (object) { object.has_one_record }, options: :blueprint_method_options
  attribute :blueprint_method_options_with_object, optional: true, reader: -> (object) { object.has_one_record }, options: :blueprint_method_options_with_object
  attribute :blueprint_method_options_with_object_and_options, optional: true, reader: -> (object) { object.has_one_record }, options: :blueprint_method_options_with_object_and_options
  attribute :created_at
  attribute :updated_at

  def blueprint_method_reader
    1
  end

  def blueprint_method_reader_with_object(object)
    object.has_one_record
  end

  def blueprint_method_reader_with_options(object, options)
    object.has_one_record if options[:option]
  end

  def blueprint_method_if
    true
  end

  def blueprint_method_if_with_object(object)
    object.boolean_column
  end

  def blueprint_method_if_with_object_and_options(object, options)
    object.boolean_column && options[:option]
  end

  def blueprint_method_unless
    true
  end

  def blueprint_method_unless_with_object(object)
    object.boolean_column
  end

  def blueprint_method_unless_with_object_and_options(object, options)
    object.boolean_column && options[:option]
  end

  def blueprint_method_options
    {
      nested_option: true
    }
  end

  def blueprint_method_options_with_object(object)
    {
      nested_option: object.boolean_column
    }
  end

  def blueprint_method_options_with_object_and_options(object, options)
    {
      nested_option: object.boolean_column && options[:option]
    }
  end
end

class HasOneRecordBlueprint < ApplicationBlueprint
  attribute :id
  attribute :integer_column
  attribute :float_column
  attribute :boolean_column
  attribute :string_column
  attribute :datetime_column
  attribute :integer_method
  attribute :integer_column_if_with_object_and_options, reader: -> (object) { object.integer_column }, if: -> (object, options) { object.integer_column if options[:option] && options[:nested_option] }
  attribute :created_at
  attribute :updated_at
end

class HasManyRecordBlueprint < ApplicationBlueprint
  attribute :id
  attribute :record, optional: true
  attribute :integer_column
  attribute :float_column
  attribute :boolean_column
  attribute :string_column
  attribute :datetime_column
  attribute :integer_method
  attribute :created_at
  attribute :updated_at
end

class HasAndBelongsToManyRecordBlueprint < ApplicationBlueprint
  attribute :id
  attribute :integer_column
  attribute :float_column
  attribute :boolean_column
  attribute :string_column
  attribute :datetime_column
  attribute :integer_method
  attribute :created_at
  attribute :updated_at
end