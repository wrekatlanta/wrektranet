# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "Event Title"
    start_time { Time.zone.today.beginning_of_day + 1.day + 20.hours }
    end_time nil
    all_day false
  end
end
