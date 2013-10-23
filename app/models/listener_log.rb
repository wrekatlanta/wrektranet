class ListenerLog < ActiveRecord::Base
  
  [:hd2_128, :main_128, :main_24].each do |attribute|
    validates attribute, presence: true
  end

  scope :today, -> { where('created_at >= ?', 24.hours.ago) }

  def to_highcharts
    
  end
end
