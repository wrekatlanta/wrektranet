class Admin::ProgramLogEntrySchedulesController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, ProgramLogEntrySchedule

    @program_log_entry_schedules = @program_log_entry_schedules.
      paginate(page: params[:page], per_page: 30)
  end

  def new
  end

  def create
    @program_log_entry_schedule = ProgramLogEntrySchedule.new(program_log_entry_schedule_params)
    authorize! :create, @program_log_entry_schedule

    if @program_log_entry_schedule.save
      redirect_to admin_program_log_entry_schedules_path, success: "Program log schedule created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @program_log_entry_schedule.update_attributes(program_log_entry_schedule_params)
      redirect_to admin_program_log_entry_schedules_path, success: "Program log schedule updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @program_log_entry_schedule.destroy
      redirect_to admin_program_log_entry_schedule_schedules_path, success: "Program log schedule deleted successfully."
    else
      render :edit
    end
  end

  private
    def program_log_entry_schedule_params
      params.require(:program_log_entry_schedule).permit(
        :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday,
        :start_date, :expiration_date, :start_time, :end_time, :repeat_interval,
        :program_log_entry_id
      )
    end
end