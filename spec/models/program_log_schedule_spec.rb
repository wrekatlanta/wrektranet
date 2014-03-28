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

require 'spec_helper'

describe ProgramLogSchedule do
  pending "add some examples to (or delete) #{__FILE__}"
end
