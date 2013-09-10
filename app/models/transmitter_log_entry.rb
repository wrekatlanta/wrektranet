class TransmitterLogEntry < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :sign_in, presence: true

  scope :today, ->{ where("sign_in > ? and sign_out < ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }

end
