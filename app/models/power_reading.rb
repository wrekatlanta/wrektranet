class PowerReading < ActiveRecord::Base
  before_validation :scrape_reading

  validates :plate_current, presence: true
  validates :plate_voltage, presence: true
  validates :power_out, presence: true


  private
    def scrape_reading      
      # Obviously this will change to the transmitter IP later on.
      file = File.join(Rails.public_path, 'sample.xml')

      doc = Nokogiri::XML::Reader(open(file))
      doc.each do |node|

        case node.attribute('name')
        when "PLTCUR"
          self.plate_current = node.attribute('value')
        when "PLTVLT"
          self.plate_voltage = node.attribute('value')
        when "PWROUT"
          self.power_out = node.attribute('value')
        end

      end

    end
end
