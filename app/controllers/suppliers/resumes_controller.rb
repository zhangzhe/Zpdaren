class Suppliers::ResumesController < Suppliers::BaseController

  def index
    if params[:key].present?
      @resumes = current_supplier.resumes.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = current_supplier.resumes
    end
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def new
    @resume = Resume.new
    if params[:job_id].present?
      @job = Job.find(params[:job_id])
      @resume.deliveries.build()
    end
  end

  def show
    @resume = current_supplier.resumes.find(params[:id])
  end

  def create
    @resume = Resume.new(resume_params)
    if @resume.save
      current_supplier.resumes << @resume
      message = '简历上传成功。我们会尽快审核，请耐心等待。' if params[:job_id]
      flash[:success] = message || '简历上传成功。'
      if params[:job_id]
        unless current_supplier.weixin
          delivery = Delivery.find_by_resume_id_and_job_id(@resume.id, params[:job_id])
          redirect_to suppliers_qr_code_path(delivery, job_id: params[:job_id]) and return
        else
          redirect_to suppliers_job_path(params[:job_id]) and return
        end
      else
        redirect_to suppliers_resumes_path and return
      end
    else
      flash[:error] = @resume.errors.full_messages.first
      @job = Job.find(params[:job_id]) if params[:job_id]
      render 'new' and return
    end
  end

  def download
    resume = current_supplier.resumes.find(params[:id])
    send_file resume.attachment.file.file
  end

  def select_list
    @job = Job.find(params[:job_id])
    if params[:key].present?
      @resumes = current_supplier.resumes.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = current_supplier.resumes
    end
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def destroy
    resume = current_supplier.resumes.find(params[:id])
    unless resume.has_any_after_paid_deliveries?
      if resume.resume_recover
        flash[:success] = '简历删除成功。'
        redirect_to suppliers_resumes_path
      else
        flash[:error] = '程序异常，删除失败。'
        redirect_to suppliers_resumes_path
      end
    else
      flash[:error] = '该简历已被招聘方付费，不能删除。'
      redirect_to :back
    end
  end

  private
  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment, :mobile, :auto_delivery, :remark, deliveries_attributes: [:message, :job_id])
  end
end
