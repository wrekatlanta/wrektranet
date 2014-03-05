# == Schema Information
#
# Table name: FORMAT
#
#  id          :integer          not null, primary key
#  format_name :string(20)
#  av_category :string(3)
#

class Legacy::Format < Legacy::OracleBase
  self.table_name = 'FORMAT'
end
