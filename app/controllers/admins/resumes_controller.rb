class Admins::ResumesController < Admins::BaseController

  def index
    @resumes = Resume.unactive
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  def check_and_update
    resume = Resume.update(params[:id], resume_params)
    redirect_to admins_resumes_path
  end

  def original_resume_download
    resume = Resume.find(params[:id])
    send_file resume.attachment.file.file
  end

  private
  def resume_params
    params[:resume][:checked] = true
    params.require(:resume).permit(:name, :mobile, :email, :description, :checked, :tag_list)
  end
end
