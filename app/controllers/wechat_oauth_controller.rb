class WechatOauthController < ApplicationController
  def callback
    response = Weixin.get_access_token(params[:code])
    remote_data = JSON(response.body)
    user = Commenter.where(provider: "wechat", open_id: remote_data["openid"]).first_or_create

    if !user.persisted?
      unless user.update_attributes(:email => "#{remote_data["openid"]}@wechat.com", :password => remote_data["openid"])
        raise ActiveRecord::Rollback, user.errors.messages
      end
    end

    response = Weixin.user_info(remote_data["access_token"], remote_data["openid"])
    remote_data = JSON(response.body)
    user.create_or_update_weixin_from_remote(remote_data)
    sign_in(user)
    redirect_to(session[:return_to] || "/")
    session[:return_to] = nil
  end
end
