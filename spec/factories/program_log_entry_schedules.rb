# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program_log_entry_schedule do
    program_log_entry nil
    start_date "2013-11-07"
    expiration_date "2013-11-07"
    start_time "2013-11-07 15:40:53"
    end_time "2013-11-07 15:40:53"
    repeat_interval 1
    sunday false
    monday false
    tuesday false
    wednesday false
    thursday false
    friday false
    saturday false
  end
end
