class Legacy::Album < Legacy::OracleBase
  self.table_name = 'ALBUM'

  belongs_to :organization, foreign_key: :org_id
end