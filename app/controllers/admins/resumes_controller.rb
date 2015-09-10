class Admins::ResumesController < Admins::BaseController

  def index
    @resumes = Resume.all
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  def check_and_update
    resume = Resume.update(params[:id], resume_params)
    resume.approve!
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
end
