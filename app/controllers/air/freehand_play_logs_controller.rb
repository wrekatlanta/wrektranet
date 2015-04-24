class Air::FreehandPlayLogsController < Air::BaseController
  respond_to :json

  def index
    @play_logs = Legacy::PlaylistOpEntry
    .includes(:staff, :format)
    .recent.limit(30).up_to(1.hour)
  end

  def create
    @play_log = Legacy::PlaylistOpEntry.new(freehand_play_log_params)
    authorize! :create, @play_log
    @play_log[:format] = 12
    @play_log.album_id = 0
    @play_log.show_id = freehand_play_log_params[:show_id]
    @play_log.label = freehand_play_log_params[:label].blank? ? freehand_play_log_params[:performance_by] : nil
    # set to automation by default
    @play_log.played_by = current_user.legacy_id || -1
    @play_log.playtime = Time.zone.now

    shows = Legacy::Show.specialty_shows
    day = Time.zone.now.strftime("%A")[0..1].downcase
    hour = Time.new(1970,1,1,Time.zone.now.hour)
    hour = Time.new(1970,1,1,17)
    current = shows.where(id: Legacy::ShowSchedule.select("show_id").where(days: day).where("start_time <= ?", hour).where("end_time > ?", hour)).first

    if current.nil?
      @play_log.show_id = nil
    else
      @play_log.show_id = current.id
      @play_log.show_name = current.name
    end

    @play_log.save

    render json: @play_log.to_builder.target!
  end

  def destroy
    @play_log = Legacy::PlaylistOpEntry.find(params[:id])
    authorize! :destroy, @play_log

    if @play_log.destroy
      respond_with success: true
    end
  end

  def adjust_time
    @play_log = Legacy::PlaylistOpEntry.find(params[:id])
    authorize! :update, @play_log

    offset = params["minutes"].to_i

    if offset >= -10 and offset <= 10
      @play_log.adjust_time!(offset.minutes)
    end

    render json: @play_log.to_builder.target!
  end

  private
  def freehand_play_log_params
    params.require(:freehand_play_log).permit(:performance_by, :track_title, :album_title, :side, :track, :org_name, :show_id, :label, :format)
  end
end