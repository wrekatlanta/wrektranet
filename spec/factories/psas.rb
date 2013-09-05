# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psa do
    title "Chip Alert"
    body "Chip is very horny today."
    status "new"
    expiration_date Date.tomorrow
  end
end
