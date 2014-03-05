# == Schema Information
#
# Table name: PSA_LOG
#
#  av_name  :string(13)
#  playtime :datetime
#

class Legacy::PsaLog < Legacy::OracleBase
  self.table_name = 'PSA_LOG'

  belongs_to :playable_spot, primary_key: :av_name, foreign_key: :av_name
end
