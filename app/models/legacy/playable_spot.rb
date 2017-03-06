# == Schema Information
#
# Table name: PLAYABLE_SPOTS
#
#  av_name     :string(40)
#  description :string(40)
#  category    :string(3)
#  start_date  :datetime
#  kill_date   :datetime
#

class Legacy::PlayableSpot < Legacy::OracleBase
  self.table_name = 'PLAYABLE_SPOTS'

  has_many :psa_logs, primary_key: :av_name, foreign_key: :av_name
  has_many :promo_logs, primary_key: :av_name, foreign_key: :av_name

  scope :active, -> {
    today = Time.zone.now.beginning_of_day

    includes(:psa_logs)
      .where("(start_date IS NULL or start_date <= :current)
              AND (kill_date IS NULL or kill_date >= :current)
              AND category = 'PSA'", current: today)

    includes(:promo_logs)
      .where("(start_date IS NULL or start_date <= :current)
              AND (kill_date IS NULL or kill_date >= :current)
              AND category = 'PRO'", current: today)
  }

  def last_play
    @last_play ||= self.psa_logs.max_by { |log| log.playtime }
  end

  def play_count(days = 7)
    now = Time.zone.now

    self.psa_logs.map { |log| ((now - log.playtime).to_i / 1.day) < 7 }
                 .keep_if { |x| x }.count
  end

  def status
    plays = self.play_count

    if plays < 5
      'success'
    elsif plays < 9
      'warning'
    else
      'danger'
    end
  end
end
