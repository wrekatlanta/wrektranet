# == Schema Information
#
# Table name: calendars
#
#  id               :integer          not null, primary key
#  url              :string(255)
#  name             :string(255)
#  default_location :string(255)
#  weeks_to_show    :integer          default(1)
#  created_at       :datetime
#  updated_at       :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :calendar do
    url "MyString"
    name "MyString"
    default_location "MyString"
  end
end
