# == Schema Information
#
# Table name: PLAY_LOG
#
#  play_log_id :integer          not null, primary key
#  track_id    :integer
#  playtime    :datetime
#  played_by   :integer
#

class Legacy::PlayLog < Legacy::OracleBase
  self.table_name = 'PLAY_LOG'
  self.primary_key = 'play_log_id'

  belongs_to :track
  belongs_to :staff, primary_key: :id, foreign_key: :played_by

  scope :recent, -> { order('playtime desc') }
  scope :up_to, -> (time = 1.hour) {
    cutoff = Time.zone.now - time
    where("playtime > :cutoff_time", cutoff_time: cutoff)
  }

  def user
    staff = self.staff

    if self.played_by == -1 or staff.nil?
      Legacy::Staff.new(initials: 'auto')
    else
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

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :playtime)
      json.track self.track, :track_id, :side, :track, :track_title, :performance_by, :format, :album
      json.organization self.track.album.organization, :id, :org_name
      json.user self.user, :initials, :id
    end
  end
end
