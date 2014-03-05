# == Schema Information
#
# Table name: program_log_entries
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class ProgramLogEntry < ActiveRecord::Base
  has_many :program_log_entry_schedules, dependent: :destroy

  accepts_nested_attributes_for :program_log_entry_schedules, allow_destroy: true

  validates :name, presence: true
end
