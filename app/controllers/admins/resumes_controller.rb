class Admins::ResumesController < Admins::BaseController
  def index
    if params[:state] == "uncompleted"
      @resumes = Resume.uncompleted
    elsif params[:state] == "completed"
      @resumes = Resume.completed
    else
      @resumes = Resume.all
    end
    @resumes = @resumes.tagged_with([params[:key]], any: true, wild: true) if params[:key].present?
    @resumes = @resumes.order("#{params[:sort]} #{params[:direction]}")
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  def update
    @resume = Resume.update(params[:id], resume_params)
    if @resume.errors.any?
      flash[:error] = @resume.errors.full_messages.first
      render 'edit' and return
    end
    flash[:success] = '完善成功'
    redirect_to admins_resumes_path(:state => "uncompleted")
  end

  def download
    resume = Resume.find(params[:id])
    send_file resume.attachment.file.file
  end

  private
  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :description, :mobile)
  end
end
