class Admins::ResumesController < Admins::BaseController
  def index
    if params[:key].present?
      @resumes = Resume.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = Resume.all
    end
    if params[:state] == "uncompleted"
      @resumes = @resumes.uncompleted
    elsif params[:state] == "completed"
      @resumes = @resumes.completed
    end
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
