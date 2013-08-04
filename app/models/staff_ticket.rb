# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_type        :integer
#  contest_director_id :integer
#  awarded             :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class StaffTicket < ActiveRecord::Base
  after_destroy :destroy_suggestions

  belongs_to :user
  belongs_to :contest, polymorphic: true
  belongs_to :contest_director, class_name: "User"

  scope :suggestion, ->{ where(contest_type: "ContestSuggestion") }
  scope :official, ->{ where(contest_type: "Contest") }

  private
  def destroy_suggestions
    self.contest_was.destroy unless self.contest_was.blank?
  end
end
