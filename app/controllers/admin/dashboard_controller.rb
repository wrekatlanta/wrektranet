class Admin::DashboardController < Admin::BaseController
  before_filter :authorize_exec

  def index
  end
end