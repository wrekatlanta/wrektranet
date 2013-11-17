# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    venue
    name { Faker::Name.first_name + " " + Faker::Name.last_name }
    start_time { Time.zone.today.beginning_of_day + 1.day + 20.hours }
    age_limit 0
    pick_up false
    listener_ticket_limit 3
    staff_ticket_limit 3
    notes "Contest notes."

    trait :pick_up do
      pick_up true
    end

    trait :sent do
      sent true
    end
  end
end
