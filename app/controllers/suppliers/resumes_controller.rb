class Suppliers::ResumesController < Suppliers::BaseController
  layout "suppliers"

  def index
    @resumes = current_supplier.resumes
  end

  def create
    if Resume.find_by_mobile(params[:resume][:mobile])
      flash[:error] = '该简历已经被推荐，请换一份简历吧'
    else
      resume = Resume.create!(resume_params)
      current_supplier.resumes << resume
      if params[:job_id]
        job = Job.find(params[:job_id])
        job.delivery!(resume)
      end
    end
    redirect_to :back
  end

  private

  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment, :mobile)
  end
end
