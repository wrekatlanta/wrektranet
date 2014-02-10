class Legacy::Organization < Legacy::OracleBase
  self.table_name = 'ORGANIZATIONS'

  has_many :albums
end
