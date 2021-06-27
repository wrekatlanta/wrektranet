class Admin::DashboardController < Admin::BaseController
  before_action :authorize_exec

  def index
  end
end