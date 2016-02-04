class Weixin::BaseController < ActionController::Base
  layout 'weixin'

  before_action :weixin_authorize

  protect_from_forgery with: :exception

  private

  def current_user
    Weixin.find_by_user_name(session['open_id']).try(:user)
  end

  def weixin_authorize
    unless current_user
      if params[:code].present? && (params[:state] == "STATE")
        response = Weixin.get_access_token(params[:code])
        session['open_id'] = JSON(response.body)['openid']
      else
        redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Weixin.appid}&redirect_uri=http%3A%2F%2F#{Weixin.callback_url}/weixin/deliveries/#{params[:id]}&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect"
      end
    end
  end
end