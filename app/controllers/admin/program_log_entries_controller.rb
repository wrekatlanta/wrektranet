class Admin::ProgramLogEntriesController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, ProgramLogEntry

    @program_log_entries = @program_log_entries
      .includes(:program_log_schedules)
      .paginate(page: params[:page], per_page: 30)
  end

  def new
  end

  def create
    @program_log_entry = ProgramLogEntry.new(program_log_entry_params)
    authorize! :create, @program_log_entry

    if @program_log_entry.save
      redirect_to admin_program_log_entries_path, success: "#{@program_log_entry.title} created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @program_log_entry.update_attributes(program_log_entry_params)
      redirect_to admin_program_log_entries_path, success: "#{@program_log_entry.title} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @program_log_entry.destroy
      redirect_to admin_program_log_entries_path, success: "#{@program_log_entry.title} deleted successfully."
    else
      render :edit
    end
  end

  private
    def program_log_entry_params
      params.require(:program_log_entry).permit(
        :title, :description,
        program_log_schedules_attributes: [
          :sunday, :monday, :tuesday, :wednesday,
          :thursday, :friday, :saturday,
          :start_time, :end_time,
          :start_date_string, :expiration_date_string,
          :repeat_interval, :id, '_destroy'
        ]
      )
    end
end