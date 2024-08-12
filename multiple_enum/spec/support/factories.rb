FactoryBot.define do
  factory :record do
    colors { [Faker::Base.sample(Record.colors.keys)] }
  end
end