class InterviewsController < ActionController::Base
  layout 'anonymous_job'
  def show
    @interview = Interview.find_by_id(params[:id])
    if @interview.available? || (current_user && current_user.admin?)
      if request.user_agent =~ /MicroMessenger/ # visit from weixin
        if current_user # step 3
          # @interview = Interview.find(params[:id])
        elsif params["code"] && (params["state"] == "STATE") # step 2
          session[:return_to] = request.path
          redirect_to "/wechat_oauth/callback?code=#{params[:code]}&state=#{params[:state]}"
        else # step 1
          redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Weixin.appid}&redirect_uri=http%3A%2F%2F#{Weixin.callback_url}/interviews/#{params[:id]}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
        end
      else
        # @interview = Interview.find(params[:id])
      end
    else
      render "time_unavailable"
    end
  end
end
