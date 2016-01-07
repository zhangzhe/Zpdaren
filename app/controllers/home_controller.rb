class HomeController < ApplicationController
  protect_from_forgery :except => [:weixin_callback]
  before_action :detect_browser, :only => [:index]

  def index
    if current_user
      redirect_path = case current_user
      when Admin
        admins_jobs_path(:state => "high_priority")
      when Recruiter
        recruiters_jobs_path(:state => "submitted")
      when Supplier
        suppliers_jobs_path(:state => "high_priority")
      when Professor
        current_user.interview
      end
      redirect_to redirect_path
    end
  end

  def signup_redirection
  end

  def forget_password_redirection
  end

  def custom_agreement
    send_file "public/pdfs/custom_agreement.pdf"
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
    else
      render :nothing => true
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

  def detect_browser
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end
end
