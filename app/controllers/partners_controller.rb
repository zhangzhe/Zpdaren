class PartnersController < ApplicationController
  layout :false

  def show
    @partner = Partner.find(params[:id])
  end

  def logo_download
    partner = Partner.find(params[:id])
    send_file partner.logo.current_path
  end

  def qrcode_download
    @partner = Partner.find(params[:id])
    send_file @partner.qrcode.current_path
  end
end