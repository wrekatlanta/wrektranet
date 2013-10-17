class PowerReading < ActiveRecord::Base
  before_validation :scrape_reading

  validates :plate_current, presence: true
  validates :plate_voltage, presence: true
  validates :power_out, presence: true


  private
    def scrape_reading
      doc = Nokogiri::HTML(open(url))

      # Need to modify the php to have better selectors for values or walk through table.
      self.plate_current = doc.at_css(".level").text(/1/)
      self.plate_voltage = doc.at_css(".level").text(/2/)
      self.power_out = doc.at_css(".level").text(/3/)
    end
end
