# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staff_ticket do
    contest
    user
    awarded false

    trait :awarded do
      awarded true
      contest_director
    end
  end
end
