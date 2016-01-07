class InterviewsController < ActionController::Base
  layout 'anonymous_job'

  def show
    if request.user_agent =~ /MicroMessenger/ # visit from weixin
      if current_user
        @interview = Interview.find(params[:id])
      elsif params["code"] && (params["state"] == "STATE")
        session[:return_to] = request.path
        redirect_to "/wechat_oauth/callback?code=#{params[:code]}&state=#{params[:state]}"
      else
        session[:return_to] = request.url
        redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx0e604319f74644b3&redirect_uri=http%3A%2F%2F673df419.ngrok.io/interviews/#{params[:id]}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
      end
    else
      @interview = Interview.find(params[:id])
    end
  end
end
