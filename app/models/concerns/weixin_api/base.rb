module WeixinApi::Base
  def qrcode_url(ticket)
    "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ticket}"
  end

  def get_access_token(code)
    response = conn.get '/sns/oauth2/access_token', { :appid => appid, :secret => secret, :code => code, :grant_type => "authorization_code" }
  end

  def user_info(access_token, openid)
    conn.get '/sns/userinfo', { :access_token => access_token, :openid => openid }
  end

  def qr_code_ticket(scene_id)
    response = conn.post do |req|
      req.url "/cgi-bin/qrcode/create?access_token=#{access_token}"
      req.body = "{ \"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": { \"scene\": { \"scene_id\": #{scene_id} } } }"
    end
    response_result = JSON(response.body)
    response_result['ticket']
  end

  def callback_url
    weixin_config["callback_url"]
  end

  def appid
    weixin_config["appid"]
  end

  def conn
    Faraday.new(:url => weixin_config["url"])
  end

  private
  def access_token
    response = conn.get '/cgi-bin/token', { :appid => appid, :secret => secret, :grant_type => "client_credential" }
    JSON(response.body)['access_token']
  end

  def weixin_config
    YAML.load_file("#{Rails.root}/config/weixin.yml")["mp"]
  end

  def secret
    weixin_config["secret"]
  end
end
