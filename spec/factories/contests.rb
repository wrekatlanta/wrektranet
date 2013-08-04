# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    name "MyString"
    date "2013-08-04 17:11:25"
    venue nil
    age_limit 1
    pick_up false
    listener_tickets 1
    staff_tickets 1
    notes "MyText"
  end
end
