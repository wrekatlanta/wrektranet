class PsaReading < ActiveRecord::Base
	belongs_to :user
  	belongs_to :psa
  	attr_accessible :user, :psa
end
