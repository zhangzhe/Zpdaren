class Authentication::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def wechat
    user = Commenter.from_omniauth(request.env["omniauth.auth"])
    user.update_attributes!(:email => "#{request.env["omniauth.auth"].extra.raw_info.openid}@wechat.com", :password => request.env["omniauth.auth"].extra.raw_info.openid) unless user.persisted?
    response = Weixin.conn.get '/sns/userinfo', { :access_token => request.env["omniauth.auth"].credentials.token, :openid => request.env["omniauth.auth"].extra.raw_info.openid }
    remote_data = JSON(response.body)
    user.create_or_update_weixin_from_remote(remote_data)
    sign_in(user)
    redirect_to(request.env["omniauth.origin"])
  end
end
