class Admins::ResumesController < Admins::BaseController
  def index
    if params[:state] == "uncompleted"
      @resumes = Resume.uncompleted
    elsif params[:state] == "completed"
      @resumes = Resume.completed
    elsif params[:state] == "unavailable"
      @resumes = Resume.unavailable
    elsif params[:state] == "available"
      @resumes = Resume.available
    else
      @resumes = Resume.all
    end

    @resumes = @resumes.where(:supplier_id => params[:supplier_id]) if params[:supplier_id]
    @resumes = @resumes.tagged_with([params[:key]], any: true, wild: true) if params[:key].present?
    @resumes = @resumes.order("#{params[:sort]} #{params[:direction]}")
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def show
    @resume = Resume.find(params[:id])
  end

  def edit
    @resume = Resume.find(params[:id])
    if @resume.is_pdf?
      render 'edit_pdf' and return
    end
  end

  def update
    @resume = Resume.update(params[:id], resume_params)
    @resume.set_attachment_to_pdf_attachment(params[:resume][:reuse_attachment])
    if @resume.errors.any?
      flash[:error] = @resume.errors.full_messages.first
      render (@resume.is_pdf? ? 'edit_pdf' : 'edit') and return
    end
    flash[:success] = '完善成功'
    redirect_to admins_resumes_path(:state => "uncompleted")
  end

  def download
    resume = Resume.find(params[:id])
    send_file resume.attachment.file.file
  end

  def pdf_download
    resume = Resume.find(params[:id])
    send_file resume.pdf_attachment.file.file
  end

  private
  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :description, :mobile, :email, :available, :pdf_attachment)
  end
end
