class PLog < ActiveRecord::Base

  STATUSES = ['began', 'expired']

 validate :expiration_date_string_is_date
 validate :start_date_string_is_date

  validates :time, presence: true
  validates :Event, presence: true  
  validates :description, presence: true
  validates :start_date, presence: true

  validates :expiration_date, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :began, -> { where("start_date >= ?", Time.zone.today) }
  scope :expired, -> { where("expiration_date < ?", Time.zone.today) }


  def start_date_string
    @start_date_string || self.try(:start_date_string).try(:strftime, "%-m/%-d/%y")
  end

  def start_date_string=(value)
    @start_date_string = value
    self.start_date = parse_date(value)
  end


  def expiration_date_string
    @expiration_date_string || self.try(:expiration_date).try(:strftime, "%-m/%-d/%y")
  end

  def expiration_date_string=(value)
    @expiration_date_string = value
    self.expiration_date = parse_date(value)
  end

  private
    def start_date_string_is_date
      errors.add(:start_date_string, "is invalid") unless parse_date(start_date)
    end

    def parse_date(chronic_string)
      Chronic.parse(chronic_string)
    end

  private
    def expiration_date_string_is_date
      errors.add(:expiration_date_string, "is invalid") unless parse_date(expiration_date)
    end

    def parse_date(chronic_string)
      Chronic.parse(chronic_string)
    end




end