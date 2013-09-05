class PsaReading < ActiveRecord::Base
	belongs_to :user
  	belongs_to :psa
end
