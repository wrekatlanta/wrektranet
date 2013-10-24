class TransmitterLogEntry < ActiveRecord::Base
  belongs_to :user

  before_validation :set_expiration_time
  before_create :new_power_reading

  validates :user, presence: true
  validates :sign_in, presence: true

  scope :today, ->{ where("sign_in > ? and (sign_out < ? OR sign_out is NULL)", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
  scope :unsigned, ->{ where("sign_in IS NOT NULL and sign_out IS NULL") }


  private
    def set_expiration_time
      if not self.sign_out.nil? and not self.sign_in.nil?

        if self.sign_out.time < self.sign_in.time
          self.sign_out = self.sign_out.change(day: self.sign_in.tomorrow.day, month: self.sign_in.month, year: self.sign_in.year)
        else
          self.sign_out = self.sign_out.change(day: self.sign_in.day, month: self.sign_in.month, year: self.sign_in.year)
        end
      end
    end

    def new_power_reading
      PowerReading.create
    end

end
