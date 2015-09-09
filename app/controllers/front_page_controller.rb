class FrontPageController < ApplicationController
  protect_from_forgery :except => [:check_signature]

  def index
  end

  require 'digest/sha1'
  def check_signature
    if params["xml"] && params["xml"]["Event"] == "subscribe" && params["xml"]["EventKey"]
      user_id = params["xml"]["EventKey"].split("_").last.to_i
      user = User.find(user_id)
      user.create_weixin(:user_name => params["xml"]["FromUserName"])
      render :nothing => true
    elsif params["xml"] && params["xml"]["Event"] == "unsubscribe" && params["xml"]["EventKey"]
      weixin = Weixin.where(:user_name => "oQluvt9GRkr6jZeMyNC7sYnI_iVA").take
      weixin.destroy
      render :nothing => true
    elsif params["xml"]["echostr"]
      token = "12345qwert"
      signature = Digest::SHA1.hexdigest([token, params[:timestamp], params[:nonce]].sort.join)
      if signature == params[:signature]
        render :text => params[:echostr]
      else
        false
      end
    end
  end
end
