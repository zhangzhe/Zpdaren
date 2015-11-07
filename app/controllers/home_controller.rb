class HomeController < ApplicationController
  protect_from_forgery :except => [:check_signature, :weixin_callback]

  def supplier
    @resource = Recruiter.new
    @resource_name = "supplier"
  end

  def recruiter
    @resource = Recruiter.new
    @resource_name = "recruiter"
  end

  def signup_redirection

  end

  require 'digest/sha1'
  SIGNATURE_TOKEN = "12345qwert"
  def weixin_callback
    if subscribe_condition
      user_id = params["xml"]["EventKey"].split("_").last.to_i
      if user_id != 0
        user = User.find(user_id)
        # may cause may weixins for one user, fix later
        subscribe_user = user.create_weixin(:user_name => params["xml"]["FromUserName"])
        Weixin.send_subscribe_notification_to(subscribe_user)
      end
      render :nothing => true
    elsif unsubscribe_condition
      if weixin = Weixin.where(:user_name => params["xml"]["FromUserName"]).take
        weixin.destroy
      end
      render :nothing => true
    elsif signature_condition
      signature = Digest::SHA1.hexdigest([SIGNATURE_TOKEN, params[:timestamp], params[:nonce]].sort.join)
      if signature == params[:signature]
        render :text => params[:echostr]
      else
        false
      end
    end
  end

  private
  def subscribe_condition
    params["xml"] && (params["xml"]["Event"] == "subscribe" || params["xml"]["Event"] == "SCAN") && params["xml"]["EventKey"]
  end

  def unsubscribe_condition
    params["xml"] && params["xml"]["Event"] == "unsubscribe" && params["xml"]["EventKey"]
  end

  def signature_condition
    params["echostr"]
  end
end
