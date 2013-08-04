# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    name "George and the Burdells"
    venue
    date { Time.zone.today.beginning_of_day + 1.day + 20.hours }
    age_limit 1
    pick_up false
    listener_tickets 0
    staff_tickets 0
    notes "MyText"

    trait :pick_up do
      pick_up true
    end
  end
end
