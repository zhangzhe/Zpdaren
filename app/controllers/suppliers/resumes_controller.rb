class Suppliers::ResumesController < Suppliers::BaseController
  layout "suppliers"

  def index
    @resumes = current_supplier.resumes
  end

  def create
    if Resume.find_by_mobile(params[:resume][:mobile])
      flash[:error] = '该简历已经被推荐，请换一份简历吧'
    else
      resume = Resume.create(resume_params)
      if resume.save
        current_supplier.resumes << resume
        if params[:job_id]
          job = Job.find(params[:job_id])
          job.delivery!(resume)
        end
        flash[:success] = '简历上传成功。我们会尽快审核，请耐心等待。'
      else
        flash[:error] = resume.errors.full_messages
      end
    end
    redirect_to :back
  end

  private

  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment, :mobile, :auto_delivery)
  end
end
