class Recruiters::ResumesController < Recruiters::BaseController
  def download
    resume = Resume.where("id in (?)", current_recruiter.deliveries.map(&:resume_id)).find(params[:id])
    send_file resume.pdf_attachment.present? ? resume.pdf_attachment.file.file : resume.attachment.file.file
  end
end
