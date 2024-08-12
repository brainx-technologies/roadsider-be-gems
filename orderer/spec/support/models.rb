class Record < ActiveRecord::Base
  connection.create_table :records, force: true do |t|
    t.references :polymorphicable, polymorphic: true
    t.integer :integer_column
    t.float :float_column
    t.boolean :boolean_column
    t.string :string_column
    t.datetime :datetime_column
    t.timestamps
  end

  belongs_to :polymorphicable, polymorphic: true
  has_one :has_one_record
  has_many :has_many_records
  has_and_belongs_to_many :has_and_belongs_to_many_records

  def integer_method
    integer_column
  end

  def record_method
    has_one_record
  end
end

class HasOneRecord < ActiveRecord::Base
  connection.create_table :has_one_records, force: true do |t|
    t.references :record, foreign_key: true
    t.integer :integer_column
    t.float :float_column
    t.boolean :boolean_column
    t.string :string_column
    t.datetime :datetime_column
    t.timestamps
  end
end

class HasManyRecord < ActiveRecord::Base
  connection.create_table :has_many_records, force: true do |t|
    t.references :record, foreign_key: true
    t.integer :integer_column
    t.float :float_column
    t.boolean :boolean_column
    t.string :string_column
    t.datetime :datetime_column
    t.timestamps
  end

  belongs_to :record
end

class HasAndBelongsToManyRecord < ActiveRecord::Base
  connection.create_table :has_and_belongs_to_many_records, force: true do |t|
    t.integer :integer_column
    t.float :float_column
    t.boolean :boolean_column
    t.string :string_column
    t.datetime :datetime_column
    t.timestamps
  end
  connection.create_join_table :records, :has_and_belongs_to_many_records
end