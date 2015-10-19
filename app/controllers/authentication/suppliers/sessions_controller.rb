class Authentication::Suppliers::SessionsController < Devise::SessionsController
  include AuthenticationPathable

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    if current_user.weixin_subscribable?
      flash[:notice] += "您可以点击右上角的微信图标放大并关注我们的微信，以后您相关的账号变动会直接发送到您的微信上。"
    end
    respond_with resource, location: after_sign_in_path_for(resource)
  end

end
