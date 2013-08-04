# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name "MyString"
    fax "MyString"
    address "MyString"
    send_day_offset 1
    send_time "2013-08-04 04:54:12"
    notes "MyText"
  end
end
