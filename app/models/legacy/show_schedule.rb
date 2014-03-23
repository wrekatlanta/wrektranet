# == Schema Information
#
# Table name: showsched
#
#  id         :integer          not null, primary key
#  show_id    :integer          not null
#  relation   :integer          default(0)
#  start_date :date
#  end_date   :date
#  start_time :time             not null
#  end_time   :time             not null
#  days       :string(2)        not null
#  frequency  :string(100)
#  channel    :string(4)
#  updatedon  :timestamp        not null
#  updatedby  :integer
#  title      :string(64)
#

class Legacy::ShowSchedule < Legacy::Base
  self.table_name = 'showsched'

  belongs_to :show, primary_key: :id, foreign_key: :show_id
end
