class Suppliers::ResumesController < Suppliers::BaseController
  layout "suppliers"

  def index
    if params[:key].present?
      @resumes = current_supplier.resumes.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = current_supplier.resumes
    end
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def create
    resume = Resume.new(resume_params)
    if resume.save
      current_supplier.resumes << resume
      if params[:job_id]
        job = Job.find(params[:job_id])
        job.delivery!(resume)
      end
      flash[:success] = '简历上传成功。我们会尽快审核，请耐心等待。'
    else
      flash[:error] = resume.errors.full_messages.first
    end
    redirect_to :back
  end

  private

  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment, :mobile, :auto_delivery)
  end
end
