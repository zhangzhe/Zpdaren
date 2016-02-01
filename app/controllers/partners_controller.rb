class PartnersController < ApplicationController
  layout :false

  def show
    @partner = Partner.find(params[:id])
  end
end
