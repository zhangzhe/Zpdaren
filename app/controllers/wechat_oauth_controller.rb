class WechatOauthController < ApplicationController
  def callback
    response = Wechat.conn.get '/sns/oauth2/access_token', { :appid => Wechat.mp_appid, :secret => Wechat.mp_secret, :code => params[:code], :grant_type => "authorization_code" }
    remote_data = JSON(response.body)
    user = Commenter.where(provider: "wechat", uid: remote_data["unionid"], email: "#{remote_data['unionid']}@wechat.com").first_or_create
    response = Wechat.conn.get '/sns/userinfo', { :access_token => remote_data["access_token"], :openid => remote_data["openid"] }
    remote_data = JSON(response.body)
    commenter_detail = user.commenter_detail || user.build_commenter_detail
    commenter_detail.update_from_remote!(remote_data)
    sign_in(user)
    redirect_to(session[:return_to] || "/")
    session[:return_to] = nil
  end
end

# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx0e604319f74644b3&redirect_uri=http%3A%2F%2Fhellohuohua.com/wechat_oauth/callback&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect

# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx0e604319f74644b3&redirect_uri=http%3A%2F%2F673df419.ngrok.io/wechat_oauth/callback&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect

