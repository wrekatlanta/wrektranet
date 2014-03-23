# == Schema Information
#
# Table name: program_log_entries
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :p_log do
    time "MyString"
    Event "MyString"
    description "MyText"
  end
end
