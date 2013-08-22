# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  venue_id   :integer
#

class Contact < ActiveRecord::Base
  belongs_to :venue

  validates :email, presence: true,
            format: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end
