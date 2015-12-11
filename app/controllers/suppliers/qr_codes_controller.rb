class Suppliers::QrCodesController < Suppliers::BaseController
  layout 'qr_codes'

  def show
    ticket = Weixin.qr_code_ticket(params[:id])
    @qrcode_url = Weixin.qrcode_url(ticket)
    flash[:success] = "简历推荐成功。我们会尽快审核，请耐心等待。"
  end
end
