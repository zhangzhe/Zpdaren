require 'cache'

module WeixinApi
  module Base
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
      Cache::Redis.get('ticket') do
        response = conn.post do |req|
          req.url "/cgi-bin/qrcode/create?access_token=#{access_token}"
          req.body = "{ \"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": { \"scene\": { \"scene_id\": #{scene_id} } } }"
        end
        response_result = JSON(response.body)
        {
          value: response_result['ticket'],
          expires_in: response_result['expire_seconds']
        }
      end
    end

    def callback_url
      weixin_config["callback_url"]
    end

    def appid
      weixin_config["appid"]
    end

    def resume_status_change_template_id
      weixin_config["message_templates"]["resume_status_change_template_id"]
    end

    def delivery_award_template_id
      weixin_config["message_templates"]["delivery_award_template_id"]
    end

    def conn
      Faraday.new(:url => weixin_config["url"])
    end

    private
    def access_token
      Cache::Redis.get('access_token') do
        response = conn.get '/cgi-bin/token', { :appid => appid, :secret => secret, :grant_type => "client_credential" }
        response_result = JSON(response.body)
        {
          value: response_result['access_token'],
          expires_in: response_result['expires_in']
        }
      end
    end

    def weixin_config
      YAML.load(ERB.new(File.read("#{Rails.root}/config/weixin.yml")).result)["mp"]
    end

    def secret
      weixin_config["secret"]
    end
  end
end
