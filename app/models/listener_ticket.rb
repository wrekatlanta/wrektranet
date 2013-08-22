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
  belongs_to :contest, validate: true, counter_cache: :listener_count
  belongs_to :user
end
