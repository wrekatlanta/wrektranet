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

  natural_language_date_attr :date

  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true
  validate :date_string_is_date

  scope :archived, -> { where(archived: true) }
  scope :upcoming, -> { where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }
end
