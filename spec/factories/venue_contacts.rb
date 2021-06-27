# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :venue_contact do
    venue { nil }
    contact { nil }
  end
end
