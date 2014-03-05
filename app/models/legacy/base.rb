class Legacy::Base < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = ''
  establish_connection :"staff_legacy_#{Rails.env}"
end
