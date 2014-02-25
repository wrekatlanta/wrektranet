# == Schema Information
#
# Table name: transmitter_log_entries
#
#  id             :integer          not null, primary key
#  sign_in        :datetime
#  sign_out       :datetime
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  automation_in  :boolean          default(FALSE)
#  automation_out :boolean          default(FALSE)
#

class TransmitterLogEntry < ActiveRecord::Base
  belongs_to :user

  before_validation :set_expiration_time

  validates :user, presence: true
  validates :sign_in, presence: true

  scope :today, ->{ where("sign_in > ?", Time.zone.now.beginning_of_day) }
  scope :signed, ->{ where("sign_out IS NOT NULL") }
  scope :unsigned, ->{ where("sign_in IS NOT NULL and sign_out IS NULL") }

  def self.bucket_format(logs)
    buckets = {}
    # We will be grouping by date for better reporting
    logs.each do |log|
      ( buckets[log.sign_in.to_date] ||= [] ) << log
    end

    return buckets
  end

  # Sets a preset time out that goes up an hour from the sign_in time.
  def time_out
    @time_out = ((self.sign_in.hour + 1) % 24).to_s + ':00'
  end

  def serializable_hash(options={})
    options = { 
      methods: [:time_out]
    }.update(options)
    super(options)
  end

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

end
