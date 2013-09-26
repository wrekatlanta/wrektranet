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

  scope :archived, -> { where(archived: true) }
  scope :upcoming, -> { where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }

  def date_string
    @date_string || date.try(:strftime, "%-m/%-d/%y %-l:%M %p")
  end

  def date_string=(value)
    @date_string = value
    self.date = parse_date
  end

  private
    def date_string_is_date
      errors.add(:date_string, "is invalid") unless parse_date
    end

    def parse_date
      Chronic.parse(date_string)
    end
end
