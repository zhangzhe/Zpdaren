class Admins::ResumesController < Admins::BaseController
  def index
    params[:state] = 'uncompleted' unless current_admin.resume_state_is_legal?(params[:state])
    if params[:supplier_id]
      @supplier = Supplier.find(params[:supplier_id])
      @q = @supplier.resumes.ransack(params[:q])
    else
      @q = current_admin.find_resumes_by_state(params[:state]).ransack(params[:q])
    end
    @resumes = @q.result.joins(:supplier, :tags).paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
    unless has_problem?
      if @resume.is_pdf?
        if !is_reuse? && !is_pdf?
          flash[:error] = '请上传pdf格式的简历。'
          render 'edit_pdf' and return
        end
      else
        if !is_pdf?
          flash[:error] = '请上传pdf格式的简历。'
          render 'edit' and return
        end
      end
    end
    if @resume.complete(resume_params)
      flash[:success] = '完善成功。'
      redirect_to admins_resumes_path(:state => "uncompleted") and return
    else
      flash[:error] = '程序异常，完善失败。'
      render (@resume.is_pdf? ? 'edit_pdf' : 'edit') and return
    end
  end

  def download
    resume = Resume.find(params[:id])
    send_file resume.attachment.current_path
  end

  def pdf_download
    resume = Resume.find(params[:id])
    send_file resume.pdf_attachment.current_path
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

  def has_problem?
    resume_params[:problem].present?
  end
end
