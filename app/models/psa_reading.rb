# == Schema Information
#
# Table name: psa_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  psa_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class PsaReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :psa
end
