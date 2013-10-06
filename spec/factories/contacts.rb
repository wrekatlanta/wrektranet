# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    venue
    email { Faker::Internet.email }
  end
end
