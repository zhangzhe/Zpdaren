class Admins::BaseController < ApplicationController
  helper_method :sort_direction
  before_action :default_sort, only: [:index]
  layout 'admins'

  # 管理员账户信息
  def show
  end

  private
  def sort_direction
    %w(ASC DESC).include?(params[:direction]) ? params[:direction] : 'DESC'
  end

  def default_sort
    params[:sort] ||= 'created_at' unless params[:controller] == 'admins/deliveries' && params[:action] == 'index'
    params[:direction] ||= 'DESC'
  end
end
