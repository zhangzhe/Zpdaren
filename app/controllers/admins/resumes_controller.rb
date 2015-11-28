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
    elsif params[:state] == "problemed"
      @resumes = Resume.problemed
    else
      @resumes = Resume.all
    end

    @resumes = @resumes.where(:supplier_id => params[:supplier_id]) if params[:supplier_id]
    @resumes = @resumes.where("candidate_name like ?", "%#{params[:key]}%") if params[:key].present?
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
    @resume = Resume.find(params[:id])
    if @resume.is_pdf?
      if !is_reuse? && !is_pdf?
        flash[:error] = '请上传pdf格式的简历'
        render (@resume.is_pdf? ? 'edit_pdf' : 'edit') and return
      end
      @resume.pdf_attachment = @resume.attachment
    else
      if !is_pdf?
        flash[:error] = '请上传pdf格式的简历'
        render (@resume.is_pdf? ? 'edit_pdf' : 'edit') and return
      end
    end
    @resume.attributes = resume_params

    if @resume.save
      @resume.sync_deliveries
      flash[:success] = '完善成功'
      redirect_to admins_resumes_path(:state => "uncompleted") and return
    else
      flash[:error] = @resume.errors.full_messages.first
      render (@resume.is_pdf? ? 'edit_pdf' : 'edit') and return
    end
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
    params[:resume].permit(:candidate_name, :tag_list, :mobile, :email, :available, :pdf_attachment, :problem, :remark)
  end

  def is_reuse?
   (params[:resume][:reuse_attachment] and (params[:resume][:reuse_attachment] == '1')) ? true : false
  end

  def is_pdf?
    (resume_params[:pdf_attachment] and resume_params[:pdf_attachment].original_filename.end_with?('pdf')) ? true : false
  end
end
