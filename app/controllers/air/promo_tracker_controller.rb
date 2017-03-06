class Air::PromoTrackerController < Air::BaseController

  def index
    @promo_logs = Legacy::PromoLog.includes(:playable_spots)
    puts @promo_logs
  end

  def query
    # TODO:
    # make a table equivalent for PROMO_LOG, since PLAYABLE_SPOTS is already
    # made. then, figure out a way to make the query. then it's good.
    # https://github.com/wrekatlanta/wrektranet/blob/master/app/models/legacy/play_log.rb


    promos = # somehow get the promos from the DB

    return Array.new
    #    $oradb = connect_to_oracle();
    #    $stmt = oci_parse($oradb, <<< END
    #  SELECT p.av_name, p.description, to_char(max(l.playtime), 'YYYY/MM/DD HH24:MI:SS') AS last_play,
    #    COUNT(CASE WHEN SYSDATE - l.playtime < 7 THEN '1' ELSE NULL END) AS playcount
    #  FROM playable_spots p LEFT OUTER JOIN promo_log l ON p.av_name = l.av_name
    #  WHERE (start_date IS NULL OR start_date <= SYSDATE)
    #    AND (kill_date IS NULL OR kill_date >= SYSDATE)
    #    AND category = 'PRO'
    #  GROUP BY p.av_name, p.description
    #  ORDER BY last_play asc
    #END
    #);
  end
end
