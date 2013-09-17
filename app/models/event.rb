# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  eventable_id   :integer
#  eventable_type :string(255)
#  name           :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  all_day        :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  public         :boolean          default(TRUE)
#

class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true
end
