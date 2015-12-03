class DeliveriesController < ActionController::Base

  def show
    delivery = Delivery.find(params[:id])
    if delivery.external_credential == params[:external_credential]
      send_file delivery.resume.pdf_attachment.file.file
    else
      redirect_to '/404.html'
    end
  end
end
