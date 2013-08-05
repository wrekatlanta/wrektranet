# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_director_id :integer
#  awarded             :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class StaffTicket < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest, autosave: true, validate: true
  belongs_to :contest_director, class_name: "User"

  scope :awarded, -> { where(awarded: true) }

  def award(user)
    self.contest_director = user
    self.awarded = true
  end

  def self.create_from_suggestion!(contest_suggestion, contest)
    contest_suggestion.archived = true
    contest_suggestion.save!

    ticket = StaffTicket.new
    ticket.user = contest_suggestion.user
    ticket.contest = contest
    ticket.created_at = contest_suggestion.created_at
    ticket.save!
    ticket
  end
end
