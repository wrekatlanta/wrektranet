# == Schema Information
#
# Table name: psas
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  body            :text
#  status          :string(255)
#  expiration_date :date
#  created_at      :datetime
#  updated_at      :datetime
#

class Psa < ActiveRecord::Base

	STATUSES = ['new', 'approved', 'rejected']

	has_many :psa_readings, -> { order('created_at DESC') }

  validate :expiration_date_string_is_date
  validate :bad_expiration_date, on: :create

	validates :title, presence: true
	validates :body, presence: true
	validates :expiration_date, presence: true
	validates :status, inclusion: { in: STATUSES }


	scope :unexpired, -> { where("expiration_date >= ?", Time.zone.today) }
	scope :expired, -> { where("expiration_date < ?", Time.zone.today) }
  scope :approved, -> { includes(:psa_readings).where(status: 'approved') }
  scope :order_by_read, -> { includes(:psa_readings).order('psa_readings.created_at DESC NULLS LAST') }

  def bad_expiration_date
    errors.add(:expiration_date, "Cannot be in the past.") if
      !expiration_date.blank? and expiration_date < Time.zone.today
  end

  def expiration_date_string
    @expiration_date_string || self.try(:expiration_date).try(:strftime, "%-m/%-d/%y")
  end

  def expiration_date_string=(value)
    @expiration_date_string = value
    self.expiration_date = parse_date(value)
  end

  private
    def expiration_date_string_is_date
      errors.add(:expiration_date_string, "is invalid") unless parse_date(expiration_date)
    end

    def parse_date(chronic_string)
      Chronic.parse(chronic_string)
    end


end
