# == Schema Information
#
# Table name: PROMO_LOG
#
# av_name  :string(13)
# playtime :datetime
#

class Legacy::PromoLog < Legacy::OracleBase
  self.table_name = "PROMO_LOG"

  belongs_to :playable_spots, primary_key: :av_name, foreign_key: :av_name

  def last_play
    @last_play ||= self.playable_spots.max_by { |spot| spot.playtimes }
  end

  # Gets the play count of this specific promo
  def play_count(days = 7)
    now = Time.zone.now

    self.playable_spots.map { |spot| ((now - spot.playtime).to_i / 1.day) < days }
                       .keep_if { |x| x }.count
  end

end
