class Air::PsasController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 1.minute)
    @psas = @psas.unexpired.approved.order_by_read.reverse

    # cache the oracle result, rescue if oracle isn't configured
    begin
      @av_psas = Rails.cache.fetch('playable_spots', expires_in: 30.minutes) do
        Legacy::PlayableSpot
          .active
          .sort {|a,b| a.last_play.try(:playtime) <=> b.last_play.try(:playtime)}
      end
    rescue
      @av_psas = []
    end
  end

  def show
  end
end