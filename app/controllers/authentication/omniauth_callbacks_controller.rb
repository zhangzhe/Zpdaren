class Authentication::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def wechat
    user = Commenter.from_omniauth(request.env["omniauth.auth"])
    user.update_attributes!(:email => "#{request.env["omniauth.auth"].extra.raw_info.openid}@wechat.com", :password => request.env["omniauth.auth"].extra.raw_info.openid) unless user.persisted?
    response = Weixin.user_info(request.env["omniauth.auth"].credentials.token, request.env["omniauth.auth"].extra.raw_info.openid)
    remote_data = JSON(response.body)
    commenter_detail = user.commenter_detail || user.build_commenter_detail
    commenter_detail.update_from_remote!(remote_data)
    sign_in(user)
    redirect_to(request.env["omniauth.origin"])
  end
end
