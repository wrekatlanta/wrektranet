class Legacy::Album < Legacy::OracleBase
  self.table_name = 'ALBUM'
  self.primary_key = 'album_id'

  belongs_to :organization, foreign_key: :org_id
  has_many :tracks
end