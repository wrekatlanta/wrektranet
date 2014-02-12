class Legacy::PlayLog < Legacy::OracleBase
  self.table_name = 'PLAY_LOG'

  belongs_to :track
  belongs_to :staff, primary_key: :id, foreign_key: :played_by

  scope :recent, -> { order('playtime desc') }
  scope :up_to, -> (time = 1.hour) {
    cutoff = Time.zone.now - time
    where("playtime > :cutoff_time", cutoff_time: cutoff)
  }

  def user
    self.staff ||= Legacy::Staff.new(initials: 'auto')
  end

  def days_ago
    (Time.zone.now - self.playtime).to_i / 1.day
  end
end
