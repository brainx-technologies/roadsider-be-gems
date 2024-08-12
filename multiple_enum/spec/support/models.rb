class Record < ActiveRecord::Base
  connection.drop_table :records rescue nil
  connection.create_table :records, force: true do |t|
    t.integer :colors, array: true
    t.timestamps
  end

  multiple_enum colors: [:red, :green, :blue]
end