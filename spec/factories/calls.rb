# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call do
    time "2013-10-15 03:08:08"
    line 1
    number "MyString"
    shortName "MyString"
    status "MyString"
    fullName "MyString"
    duration "2013-10-15 03:08:08"
    wait "2013-10-15 03:08:08"
  end
end
