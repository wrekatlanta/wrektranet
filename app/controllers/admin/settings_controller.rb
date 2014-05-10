class Admin::SettingsController < Admin::BaseController
  def index
    @settings = Setting.unscoped
  end

  def edit
    @setting = Setting.unscoped.find(params[:id])
  end

  def update
    @setting = Setting.unscoped.find(params[:id])

    case params[:setting][:value]
    when "true"
      value = true
    when "false"
      value = false
    else
      value = params[:setting][:value]
    end

    Setting[@setting.var] = value

    redirect_to admin_settings_path, success: "Setting #{@setting.var} updated successfully."
  end
end