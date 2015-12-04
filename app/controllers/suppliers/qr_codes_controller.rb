class Suppliers::QrCodesController < Suppliers::BaseController
  layout 'qr_codes'

  def show
    ticket = Weixin.qr_code_ticket(params[:id])
    @qrcode_url = Weixin.qrcode_url(ticket)
  end
end
