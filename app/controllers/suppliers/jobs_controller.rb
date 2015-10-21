class Suppliers::JobsController < Suppliers::BaseController
  helper_method :sort_column

  def index
    @jobs = Job.all
    @jobs = Job.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%") if params[:key].present?
    @jobs = @jobs.order("#{params[:sort]} #{params[:direction]}")
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'jobs'
  end

  private
  def sort_column
    Job.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
