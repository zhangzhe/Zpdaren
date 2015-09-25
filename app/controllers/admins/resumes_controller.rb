class Admins::ResumesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:key].present?
      @resumes = Resume.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = Resume.all
    end
    @resumes = @resumes.order("#{params[:sort]} #{params[:direction]}")
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  # FIXME: refactor name
  def check_and_update
    @resume = Resume.update(params[:id], resume_params)
    if @resume.errors.any?
      flash[:error] = @resume.errors.full_messages.first
      render 'edit' and return
    end
    @resume.approve!
    redirect_to admins_resumes_path
  end

  def original_resume_download
    resume = Resume.find(params[:id])
    send_file resume.attachment.file.file
  end

  private
  def resume_params
    params.require(:resume).permit(:name, :mobile, :email, :description, :reviewed, :tag_list)
  end

  def sort_column
    Resume.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
