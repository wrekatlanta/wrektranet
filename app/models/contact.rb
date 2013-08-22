# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  notes      :text
#  created_at :datetime
#  updated_at :datetime
#

class Contact < ActiveRecord::Base
  belongs_to :venue

  validates :email, presence: true,
            format: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end
