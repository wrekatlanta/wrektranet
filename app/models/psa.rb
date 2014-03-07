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
  include NaturalLanguageDate

  STATUSES = ['new', 'approved', 'rejected']

  has_many :psa_readings, -> { order('created_at DESC') }

  natural_language_date_attr :expiration_date, :date

  validate :expiration_date_string_is_date
  validate :bad_expiration_date, on: :create

  validates :title, presence: true
  validates :body, presence: true
  validates :expiration_date, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :unexpired, -> { where("expiration_date >= ?", Time.zone.today) }
  scope :expired, -> { where("expiration_date < ?", Time.zone.today) }
  scope :approved, -> { includes(:psa_readings).where(status: 'approved') }
  scope :order_by_read, -> { includes(:psa_readings).order('psa_readings.created_at DESC') }

  def bad_expiration_date
    errors.add(:expiration_date, "cannot be in the past.") if
      !expiration_date.blank? and expiration_date < Time.zone.today
  end
end
