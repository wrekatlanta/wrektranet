class Legacy::PsaLog < Legacy::OracleBase
  self.table_name = 'PSA_LOG'

  belongs_to :playable_spot, primary_key: :av_name, foreign_key: :av_name
end
