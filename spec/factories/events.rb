# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    eventable nil
    name "MyString"
    start_time "2013-09-17 14:34:54"
    end_time "2013-09-17 14:34:54"
    all_day false
  end
end
