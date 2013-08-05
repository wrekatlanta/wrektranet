# == Schema Information
#
# Table name: contest_suggestions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  venue      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  archived   :boolean          default(FALSE)
#

class ContestSuggestion < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true

  scope :archived, ->{ where(archived: true) }

  attr_accessible :name, :date, :venue, :archived
end
