# == Schema Information
#
# Table name: listener_logs
#
#  id         :integer          not null, primary key
#  hd2_128    :integer
#  main_128   :integer
#  main_24    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ListenerLog < ActiveRecord::Base
  
  [:hd2_128, :main_128, :main_24].each do |attribute|
    validates attribute, presence: true
  end

  scope :today, -> { where('created_at >= ?', 24.hours.ago) }
  scope :range, -> (start_time = 24.hours.ago, end_time = Time.zone.now) {
    where('created_at >= ? and created_at <= ?', start_time, end_time)
  }

  def to_highcharts
    
  end
end
