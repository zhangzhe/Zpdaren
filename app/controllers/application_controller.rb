class String
  def controller_profix
    self.split("/").try(:first).try(:titleize).try(:singularize)
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include DeviseHelper
  before_filter :authorize

  # 3 roles: admins, recruiters, suppliers, the function under these 3 roles would be only used by the role
  def authorize
    roles = ["Admin", "Recruiter", "Supplier"]
    controller_route_profix = params[:controller].controller_profix
    if roles.include?(controller_route_profix)
      if current_user.type == controller_route_profix
      else
        redirect_to root_url, :alert => "没有权限，请联系管理员！"
      end
    end
  end
end
