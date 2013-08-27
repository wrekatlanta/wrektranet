# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psa do
    title "MyString"
    body "MyText"
    status "MyString"
    expiration_date "2013-08-27"
  end
end
