class Suppliers::BaseController < ApplicationController
  helper_method :sort_direction
  layout 'suppliers'

  def show

  end

  private
  def sort_direction
    %w(ASC DESC).include?(params[:direction]) ? params[:direction] : 'DESC'
  end
end
