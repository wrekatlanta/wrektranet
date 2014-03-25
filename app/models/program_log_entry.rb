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

class ProgramLogEntry < ActiveRecord::Base
  has_many :program_log_schedules, dependent: :destroy

  accepts_nested_attributes_for :program_log_schedules, allow_destroy: true

  validates :title, presence: true
end
