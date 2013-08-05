# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listener_ticket do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    contest
    user
  end
end
