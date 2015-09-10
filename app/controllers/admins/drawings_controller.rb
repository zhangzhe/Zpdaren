class Admins::DrawingsController < ApplicationController
  layout 'admins'

  def index
    @drawings = Drawing.all
  end

  def review
    drawing = Drawing.find(params[:id])
    drawing.review!(params[:opt])
    redirect_to :back
  end
end