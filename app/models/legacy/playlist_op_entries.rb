# == Schema Information
#
# Table name: PLAYLIST_OP_ENTRIES
#
#  performance_by :string(70)
#  track_title    :string(70)
#  album_title    :string(70)
#  side           :string(4)
#  track          :string(4)
#  label          :string(70)
#  playtime       :datetime
#  played_by      :integer
#  id             :integer          primary key
#  album_id       :integer
#  format         :integer
#

class Legacy::PlaylistOpEntries < Legacy::OracleBase
  self.table_name = 'PLAYLIST_OP_ENTRIES'
  self.primary_key = 'id'

  belongs_to :staff, primary_key: :id, foreign_key: :played_by

  scope :recent, -> { order('playtime desc') }
  scope :up_to, -> (time = 1.hour) {
    cutoff = Time.zone.now - time
    where("playtime > :cutoff_time", cutoff_time: cutoff)
  }

  def user
    if self.played_by == -1 or staff.nil?
      Legacy::Staff.new(initials: 'auto')
    else
      staff = self.staff
      staff.initials.downcase!
      staff
    end
  end

  def days_ago
    (Time.zone.now - self.playtime).to_i / 1.day
  end

  def adjust_time! offset
    self.playtime += offset
    self.save
  end

  # def to_builder
  #   Jbuilder.new do |json|
  #     json.(self, :id, :playtime)
  #     json.track.(self, :track_title, :performance_by, :format, :album_title)
  #     json.organization.(self, :org_name)
  #     json.user self.user, :initials, :id
  #   end
  # end

end
