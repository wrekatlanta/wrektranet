# == Schema Information
#
# Table name: listener_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone      :string(255)
#  contest_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ListenerTicket < ActiveRecord::Base
  belongs_to :contest, counter_cache: :listener_count
  belongs_to :user

  validate :ticket_count_within_limit, on: :create
  validates :user, presence: true
  validates :name, presence: true

  private
    def ticket_count_within_limit
      if self.contest.listener_tickets(:reload).size >= self.contest.listener_ticket_limit
        errors.add(:base, "Too many listener tickets")
      end
    end
end
