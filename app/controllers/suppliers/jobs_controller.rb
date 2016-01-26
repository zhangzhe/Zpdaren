class Suppliers::JobsController < Suppliers::BaseController

  def index
    @q = current_supplier.find_jobs_by_state(params[:state]).ransack(params[:q])
    @jobs = @q.result(distinct: true)
    @jobs = @jobs.where("jobs.user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.tagged_with(params[:tag]) if params[:tag]
    @jobs = @jobs.joins(:company).paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
      render 'welcome'
    end
  end
end
