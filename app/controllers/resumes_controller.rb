class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
  end

  def create
    begin
      resume = Resume.create!(create_resume_params)
      # redirect_to resumes_path
      render json: {} and return
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = '不支持该格式的文件上传'
      redirect_to :back
    end
  end

  def create_and_deliver
    job = Job.find(params[:job_id])
    resume = Resume.create!(resume_params)
    job.delivery!(resume)
    redirect_to :back
  end

  def edit
    unless @resume = Resume.find_by_id(params[:id])
      redirect_to '/404.html'
    end
  end

  def update
    resume = Resume.update(params[:id], update_resume_params)
    redirect_to admin_resumes_path
  end

  def destroy

  end

  def download
    if resume = Resume.find_by_id(params[:id])
      send_file resume.attachment.file.file
    end
  end

  private
  def create_resume_params
    params.require(:resume).permit(:name, :attachment, :tag_list)
  end

  def update_resume_params
    params[:resume][:checked] = true
    params.require(:resume).permit(:name, :mobile, :email, :description, :checked, :tag_list)
  end

  def resume_params
    params[:resume].permit(:candidate_name, :tag_list, :attachment)
  end
end
