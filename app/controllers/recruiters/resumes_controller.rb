class Recruiters::ResumesController < Recruiters::BaseController
  def download
    resume = Resume.find(params[:id])
    send_file resume.pdf_attachment.file.file
  end
end