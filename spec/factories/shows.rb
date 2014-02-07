# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    legacy_id 1
    name "MyString"
    long_name "MyString"
    short_name "MyString"
    url "MyString"
    description "MyString"
    category "MyString"
    email "MyString"
    facebook "MyString"
    twitter "MyString"
  end
end
