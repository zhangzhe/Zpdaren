class HomeController < ApplicationController
  protect_from_forgery :except => [:check_signature, :weixin_callback]

  def index
  end

  require 'digest/sha1'
  SIGNATURE_TOKEN = "12345qwert"
  # FIXME: deploy steps: 0. remove check_signature; 1. deploy; 2. change callback config in Weixin server; 3. test wixin unsubscribe/subscribe
  def weixin_callback
    if subscribe_condition
      user_id = params["xml"]["EventKey"].split("_").last.to_i
      user = User.find(user_id)
      subscribe_user = user.create_weixin(:user_name => params["xml"]["FromUserName"])
      Weixin.send_subscribe_notification_to(subscribe_user)
      render :nothing => true
    elsif unsubscribe_condition
      weixin = Weixin.where(:user_name => params["xml"]["FromUserName"]).take
      weixin.destroy
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

  def check_signature
    if subscribe_condition
      user_id = params["xml"]["EventKey"].split("_").last.to_i
      user = User.find(user_id)
      subscribe_user = user.create_weixin(:user_name => params["xml"]["FromUserName"])
      Weixin.send_subscribe_notification_to(subscribe_user)
      render :nothing => true
    elsif unsubscribe_condition
      weixin = Weixin.where(:user_name => params["xml"]["FromUserName"]).take
      weixin.destroy
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
    params["xml"] && params["xml"]["Event"] == "subscribe" && params["xml"]["EventKey"]
  end

  def unsubscribe_condition
    params["xml"] && params["xml"]["Event"] == "unsubscribe" && params["xml"]["EventKey"]
  end

  def signature_condition
    params["echostr"]
  end
end
