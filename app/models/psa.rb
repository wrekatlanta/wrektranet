class Psa < ActiveRecord::Base
	has_many :psa_readings, -> { order('created_at DESC') }

	validates :title, presence: true
	validates :body, presence: true
	validates :expiration_date, presence: true
	validates :status, inclusion: { in: ['new', 'approved', 'rejected'] }


	scope :unexpired, -> { {conditions: ["expiration_date > ?", Date.today]} }
  	scope :approved, -> { includes(:psa_readings).where(status: 'approved') }
  	scope :order_by_read, -> { includes(:psa_readings).order('psa_readings.created_at DESC') }


end
