class Admins::JobsController < Admins::BaseController
  def index
    if params[:state] == "in_hiring"
      @jobs = Job.in_hiring
    elsif params[:state] == "un_hiring"
      @jobs = Job.un_hiring
    elsif params[:state] == "deleted"
      @jobs = Job.only_deleted
    elsif params[:state] == "not_paid"
      @jobs = Job.submitted
    elsif params[:state] == 'high_priority'
      @jobs = Job.high_priority
    else
      @jobs = Job.all
    end
    @jobs = @jobs.where("title like ?", "%#{params[:key]}%") if params[:key].present?
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
    redirect_to admins_job_path(@job)
  end

  def priority_update
    job = Job.find(params[:id])
    job.priority = params[:priority]
    if job.save
      render json: { status: 200 }
    else
      render json: { status: 500 }
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
    # render xlsx: '职位列表', template: 'export'
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
