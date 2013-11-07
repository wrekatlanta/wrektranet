# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psa_reading do
    user
    psa
  end
end
