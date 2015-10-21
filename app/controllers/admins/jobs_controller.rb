class Admins::JobsController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:key].present?
      @jobs = Job.where("title ilike ?", "%#{params[:key]}%")
    else
      @jobs = Job.all
    end
    @jobs = @jobs.order("#{params[:sort]} #{params[:direction]}")
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

  def sort_column
    Job.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
