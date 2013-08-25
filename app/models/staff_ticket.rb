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
  belongs_to :contest, validate: true, counter_cache: :staff_count
  belongs_to :contest_director, class_name: "User"

  scope :awarded, -> { where(awarded: true) }

  validate :ticket_count_within_limit, on: :create

  def award!(user)
    self.contest_director = user
    self.awarded = true
    self.save!
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

  private
    def ticket_count_within_limit
      if self.contest.staff_tickets(:reload).size >= self.contest.staff_ticket_limit
        errors.add(:base, "Too many staff tickets")
      end
    end
end
