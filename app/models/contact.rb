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
  has_many :venues
end
