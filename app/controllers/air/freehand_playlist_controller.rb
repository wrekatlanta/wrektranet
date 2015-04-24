class Air::FreehandPlaylistController < Air::BaseController
  def index
    @shows = Legacy::Show.specialty_shows
    day = Time.zone.now.strftime("%A")[0..1].downcase
    hour = Time.new(1970,1,1,Time.zone.now.hour)
    hour = Time.new(1970,1,1,12)
    current = @shows.where(id: Legacy::ShowSchedule.select("show_id").where(days: day).where("start_time <= ?", hour).where("end_time > ?", hour)).first
    if current.nil?
      @current_show = ""
    else
      @current_show = "Current show: " + current.name
    end
  end
end
