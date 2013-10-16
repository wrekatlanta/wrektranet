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

end
