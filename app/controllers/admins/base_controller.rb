class Admins::BaseController < ApplicationController
  helper_method :sort_direction
  before_action :default_sort, only: [:index]
  layout 'admins'

  private
  def sort_direction
    %w(ASC DESC).include?(params[:direction]) ? params[:direction] : 'DESC'
  end

  def default_sort
    params[:sort] ||= 'created_at'
    params[:direction] ||= 'DESC'
  end
end
