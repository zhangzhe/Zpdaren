class ResumesController < ActionController::Base

  def show
    resume = Resume.find(params[:id])
    if resume.external_credential == params[:external_credential]
      send_file resume.pdf_attachment.current_path
    else
      redirect_to '/404.html'
    end
  end
end
