class DeliveriesController < ActionController::Base

  def show
    delivery = Delivery.find(params[:id])
    if delivery.external_credential_valid?(params[:external_credential])
      send_file delivery.resume.pdf_attachment.file.file
    end
  end
end
