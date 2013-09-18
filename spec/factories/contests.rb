# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    event
    venue
    age_limit 0
    pick_up false
    listener_ticket_limit 3
    staff_ticket_limit 3
    notes "Contest notes."

    trait :pick_up do
      pick_up true
    end
  end
end
