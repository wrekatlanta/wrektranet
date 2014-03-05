# == Schema Information
#
# Table name: transmitter_log_entries
#
#  id             :integer          not null, primary key
#  sign_in        :datetime
#  sign_out       :datetime
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  automation_in  :boolean          default(FALSE)
#  automation_out :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transmitter_log_entry do
    sign_in "2013-09-04 20:00:00"
    sign_out "2013-09-04 21:00:00"
    user
    automation_in false
    automation_out true
  end
end
