class Wechat
  class << self
    def mp_appid
      mp_config["appid"]
    end

    def mp_secret
      mp_config["secret"]
    end

    def conn
      Faraday.new(:url => 'https://api.weixin.qq.com')
    end

    private
    def mp_config
      YAML.load_file("#{Rails.root}/config/weixin.yml")["mp"]
    end
  end
end
