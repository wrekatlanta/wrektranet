class Legacy::OracleBase < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = ''
  establish_connection :"oracle_legacy_#{Rails.env}"
end
