class Suppliers::JobsController < Suppliers::BaseController
  helper_method :sort_column

  def index
    @jobs = Job.available
    @jobs = @jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%") if params[:key].present?
    @jobs = @jobs.order("#{params[:sort]} #{params[:direction]}")
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    select_show_page
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

  def select_show_page
    if cookies["supplier_#{current_user.id}"].blank?
      @ticket = Weixin.qr_code_ticket(current_user.id)
      cookies["supplier_#{current_user.id}"] = Time.now
      render 'welcome'
    else
      render 'index'
    end
  end
end
