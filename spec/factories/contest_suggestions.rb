# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest_suggestion do
    user
    name { Faker::Name.first_name + " " + Faker::Name.last_name }
    date { Time.zone.today.beginning_of_day + 1.day }
    venue "Under the Couch"
  end
end
