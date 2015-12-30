class Recruiters::ResumesController < Recruiters::BaseController
  def download
    resume = Resume.where("id in (?)", current_recruiter.deliveries.map(&:resume_id)).find(params[:id])
    send_file resume.pdf_attachment.current_path
  end
end
