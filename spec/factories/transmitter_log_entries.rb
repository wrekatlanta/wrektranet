# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transmitter_log_entry do
    sign_in "2013-09-04 23:24:04"
    sign_out "2013-09-04 23:24:04"
    user_id 1
    automation false
  end
end
