FactoryBot.define do
  factory :record do
    integer_column { Faker::Number.between.to_i }
    float_column { Faker::Number.between }
    boolean_column { Faker::Boolean.boolean }
    string_column { Faker::Lorem.word }
    datetime_column { Faker::Date.birthday }

    factory :record_with_relations do
      polymorphicable { create([:record, :has_one_record, :has_many_record, :has_and_belongs_to_many_record].sample) }
      has_one_record { create(:has_one_record) }
      has_many_records { create_list(:has_many_record, 3) }
      has_and_belongs_to_many_records { create_list(:has_and_belongs_to_many_record, 3) }
    end
  end
end

FactoryBot.define do
  factory :has_one_record do
    integer_column { Faker::Number.between.to_i }
    float_column { Faker::Number.between }
    boolean_column { Faker::Boolean.boolean }
    string_column { Faker::Lorem.word }
    datetime_column { Faker::Date.birthday }
  end
end

FactoryBot.define do
  factory :has_many_record do
    integer_column { Faker::Number.between.to_i }
    float_column { Faker::Number.between }
    boolean_column { Faker::Boolean.boolean }
    string_column { Faker::Lorem.word }
    datetime_column { Faker::Date.birthday }
  end
end

FactoryBot.define do
  factory :has_and_belongs_to_many_record do
    integer_column { Faker::Number.between.to_i }
    float_column { Faker::Number.between }
    boolean_column { Faker::Boolean.boolean }
    string_column { Faker::Lorem.word }
    datetime_column { Faker::Date.birthday }
  end
end

FactoryBot.define do
  factory :model do
    a { Faker::Lorem.word }
    b { Faker::Lorem.word }
    c { Faker::Lorem.word }
  end
end