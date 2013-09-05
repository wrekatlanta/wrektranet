class Psa < ActiveRecord::Base

	STATUSES = ['new', 'approved', 'rejected']

	has_many :psa_readings, -> { order('created_at DESC') }


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


end
