class TransmitterLogEntry < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :sign_in, presence: true
  validates :sign_out, presence: true

end
