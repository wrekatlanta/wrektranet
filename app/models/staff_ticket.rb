# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_type        :string(255)
#  contest_director_id :integer
#  awarded             :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class StaffTicket < ActiveRecord::Base
  after_save :clean_suggestions

  belongs_to :user
  belongs_to :contest, polymorphic: true
  belongs_to :contest_director, class_name: "User"

  scope :suggestion, ->{ where(contest_type: "ContestSuggestion") }
  scope :official, ->{ where(contest_type: "Contest") }

  def clean_suggestions
    ContestSuggestion.unassigned.delete_all
  end
end
