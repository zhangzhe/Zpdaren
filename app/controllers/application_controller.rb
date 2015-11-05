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
      if current_user
        unless current_user.type == controller_route_profix
          flash[:alert] ||= "没有权限，请联系管理员！"
          redirect_to root_url
        end
      else
        flash[:alert] ||= '请先登录！'
        if request.referer.present?
          redirect_to request.referer.end_with?('/sign_in') ? :back : home_url
        else
          redirect_to home_url
        end
      end
    end
  end


  helper_method :forget_password_path_for, :register_path_for, :login_path_for
  def forget_password_path_for(resource_name)
    eval("new_#{resource_name}_password_path")
  end

  def register_path_for(resource_name)
    eval("new_#{resource_name}_registration_path")
  end

  def login_path_for(resource_name)
    eval("new_#{resource_name}_session_path")
  end
end
