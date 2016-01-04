class Suppliers::JobsController < Suppliers::BaseController

  def index
<<<<<<< HEAD
    @jobs = current_supplier.find_jobs_by_state(params[:state])
    @jobs = @jobs.tagged_with(params[:tag]) if params[:tag]
    @jobs = @jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.where("title ilike ?", "%#{params[:key]}%").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    tags = Job.tag_counts_on(:tags).order('taggings_count DESC')
    @priority_tags = tags.where(:priority => 1)
=======
    @q = current_supplier.find_jobs_by_state(params[:state]).ransack(params[:q])
    @jobs = @q.result(distinct: true)
    @jobs = @jobs.where("user_id = ? ", params[:recruiter_id]) if params[:recruiter_id]
    @jobs = @jobs.joins(:company).paginate(page: params[:page], per_page: Settings.pagination.page_size)
>>>>>>> 2cebd38857b2d638837e075b5afa76b4dbb49d4e
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
