# == Schema Information
#
# Table name: program_log_schedules
#
#  id                   :integer          not null, primary key
#  program_log_entry_id :integer
#  start_date           :date
#  expiration_date      :date
#  start_time           :time
#  end_time             :time
#  repeat_interval      :integer          default(0)
#  sunday               :boolean          default(FALSE)
#  monday               :boolean          default(FALSE)
#  tuesday              :boolean          default(FALSE)
#  wednesday            :boolean          default(FALSE)
#  thursday             :boolean          default(FALSE)
#  friday               :boolean          default(FALSE)
#  saturday             :boolean          default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program_log_schedule do
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
