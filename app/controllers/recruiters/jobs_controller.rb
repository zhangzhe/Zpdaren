class Recruiters::JobsController < Recruiters::BaseController

  def index
    if current_recruiter.company.description.blank?
      flash[:notice] = "请先完善公司信息，然后再发布职位"
      redirect_to edit_recruiters_company_path(current_recruiter.company)
    else
      @jobs = current_recruiter.jobs
      @jobs = @jobs.where("title like ?", "%#{params[:key]}%") if params[:key].present?
      @jobs = @jobs.order('created_at DESC')
      @jobs = @jobs.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end

  def new
    @job = current_recruiter.jobs.build
  end

  def create
    @job = current_recruiter.jobs.create(job_params)
    if @job.errors.any?
      flash[:error] = @job.errors.full_messages.first
      render 'new' and return
    end
    flash[:success] = "发布完成！"
    redirect_to new_recruiters_deposit_path(:job_id => @job.id)
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.update(params[:id], job_params_edit)
    if @job.errors.any?
      flash[:error] = @job.errors.full_messages.first
      render 'edit' and return
    end
    flash[:success] = "修改完成！"
    redirect_to recruiters_jobs_path
  end

  private
  def job_params
    params[:job].permit(:title, :salary_min, :salary_max, :description, :bonus, :tag_list)
  end

  def job_params_edit
    params[:job].permit(:title, :salary_min, :salary_max, :description, :tag_list)
  end
end
