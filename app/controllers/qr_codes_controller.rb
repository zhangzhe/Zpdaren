class QrCodesController < ApplicationController
  def show
    @ticket = Weixin.qr_code_ticket(params[:id])
  end
end
