class Admins::BaseController < ApplicationController
  helper_method :sort_direction
  layout 'admins'

  private
  def sort_direction
    %w(ASC DESC).include?(params[:direction]) ? params[:direction] : 'DESC'
  end
end
