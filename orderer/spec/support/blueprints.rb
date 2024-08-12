class ApplicationBlueprint < Blueprint::Base
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
  attribute :blueprint_inline_reader, optional: true, reader: -> (object) { object.has_one_record }
  attribute :blueprint_method_reader, optional: true, reader: :blueprint_method_reader
  attribute :created_at
  attribute :updated_at

  def blueprint_method_reader(object)
    object.has_one_record
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
  attribute :record_method
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
  attribute :record_method
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
  attribute :record_method
  attribute :created_at
  attribute :updated_at
end