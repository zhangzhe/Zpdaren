class Admins::JobsController < Admins::BaseController

  def index
    params[:state] = 'high_priority' unless current_admin.job_state_is_legal?(params[:state])
    @q = current_admin.find_jobs_by_state(params[:state]).ransack(params[:q])
    @jobs = @q.result(distinct: true)
    @jobs = @jobs.joins(:company).paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
      flash.now[:error] = @job.errors.full_messages.first
      render 'edit' and return
    end
    redirect_to admins_job_path(@job)
  end

  def priority_update
    job = Job.find(params[:id])
    job.priority = params[:priority]
    unless job.save
      flash[:error] = "更新失败，请联系程序员！"
    end
    respond_to do |format|
      format.js   {}
    end
  end

  def destroy
    job = Job.find(params[:id])
    if job.destroy
      flash[:success] = '职位删除成功。'
      redirect_to admins_jobs_path(state: 'in_hiring')
    else
      flash[:error] = '程序异常，删除失败。'
      redirect_to admins_jobs_path(state: 'in_hiring')
    end
  end

  def export
    @jobs = Job.all
    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="职位列表.xlsx"'
      }
    end
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :tag_list)
  end
end
