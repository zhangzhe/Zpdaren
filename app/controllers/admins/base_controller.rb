class Admins::BaseController < ApplicationController
  before_action :default_sort, only: [:index]
  layout 'admins'

  # 管理员账户信息
  def show
  end

  private
  def default_sort
    params[:sort] ||= 'created_at' unless params[:controller] == 'admins/deliveries' && params[:action] == 'index'
    params[:direction] ||= 'DESC'
  end
end
