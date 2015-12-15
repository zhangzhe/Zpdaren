class Suppliers::JobsController < Suppliers::BaseController
  helper_method :sort_column

  def index
    @jobs = Job.available
    @jobs = @jobs.high_priority if params[:state] == 'high_priority'
    @jobs = @jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%") if params[:key].present?
    @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    select_show_page
  end

  def show
    @job = Job.find(params[:id])
    @similar_jobs = @job.similar_jobs
    render layout: 'jobs'
  end

  private
  def select_show_page
    if (current_user.sign_in_count == 1) and (Time.now - current_user.current_sign_in_at <= 10)
      @ticket = Weixin.qr_code_ticket(current_user.id)
      render 'welcome'
    else
      render 'index'
    end
  end
end
