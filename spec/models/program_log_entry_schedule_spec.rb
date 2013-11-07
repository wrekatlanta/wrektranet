# == Schema Information
#
# Table name: program_log_entry_schedules
#
#  id                   :integer          not null, primary key
#  program_log_entry_id :integer
#  start_date           :date
#  expiration_date      :date
#  start_time           :time
#  end_time             :time
#  repeat_interval      :integer
#  sunday               :boolean
#  monday               :boolean
#  tuesday              :boolean
#  wednesday            :boolean
#  thursday             :boolean
#  friday               :boolean
#  saturday             :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe ProgramLogEntrySchedule do
  pending "add some examples to (or delete) #{__FILE__}"
end
