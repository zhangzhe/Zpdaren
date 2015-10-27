class Admins::JobsController < Admins::BaseController
  def index
    # if params[:key].present?
    #   @jobs = Job.where("title ilike ?", "%#{params[:key]}%")
    # else
    #   @jobs = Job.all
    # end
    if params[:state] == "in_hiring"
      @jobs = Job.in_hiring
    elsif params[:state] == "un_hiring"
      @jobs = Job.un_hiring
    else
      @jobs = Job.all
    end
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    @job.update_and_notify_supplier!(job_params)
    if @job.errors.any?
      flash[:error] = @job.errors.full_messages.first
      render 'edit' and return
    end
    redirect_to admins_jobs_path
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :tag_list)
  end
end
