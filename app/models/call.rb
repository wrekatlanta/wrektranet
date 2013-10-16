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
