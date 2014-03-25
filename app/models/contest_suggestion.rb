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
  include NaturalLanguageDate

  belongs_to :user

  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true

  default_scope -> { order('created_at DESC') }

  scope :archived, -> { where(archived: true) }
  scope :upcoming, -> { where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }

  natural_language_date_attr :date, :date
end
