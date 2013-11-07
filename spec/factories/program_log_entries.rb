# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :p_log do
    time "MyString"
    Event "MyString"
    description "MyText"
  end
end
