# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transmitter_log_entry do
    sign_in "2013-09-04 20:00:00"
    sign_out "2013-09-04 21:00:00"
    user_id 1
    automation_in false
    automation_out true
  end
end
