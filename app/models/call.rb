# == Schema Information
#
# Table name: calls
#
#  id         :integer          not null, primary key
#  time       :datetime
#  line       :integer
#  number     :string(255)
#  shortName  :string(255)
#  status     :string(255)
#  fullName   :string(255)
#  duration   :time
#  wait       :time
#  created_at :datetime
#  updated_at :datetime
#

# time:datetime
# line:integer
# number:string
# shortName:string
# status:string
# fullName:string
# duration:time
# wait:time
#
#
#
#
class Call < ActiveRecord::Base
    STATUSES = ['Warning', 'OK', 'Block']
    validates :status, inclusion: { in: STATUSES } 

    before_save :init
    def init
        self.time ||= Time.current()
        self.status ||= "OK"
    end
end
