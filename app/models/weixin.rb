class Weixin < ActiveRecord::Base
  belongs_to :user

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

    def send_subscribe_notification_to(subscribe_user)
      response = Weixin.conn.get '/cgi-bin/token', { :appid => Weixin.mp_appid, :secret => Weixin.mp_secret, :grant_type => "client_credential" }
      response_result = JSON(response.body)
      message = {
        touser: subscribe_user.user_name,
        msgtype: 'text',
        text: {
          content: '您好，欢迎关注众聘达人！'
        }
      }
      response = Weixin.conn.post do |req|
        req.url "/cgi-bin/message/custom/send?access_token=#{response_result['access_token']}"
        req.body = message.to_json
      end
    end

    def notify_resume_approved(resume)
      # {{first.DATA}}
      # 变动金额：{{keyword1.DATA}}
      # 变动时间：{{keyword2.DATA}}
      # {{remark.DATA}}
      response = Weixin.conn.get '/cgi-bin/token', { :appid => Weixin.mp_appid, :secret => Weixin.mp_secret, :grant_type => "client_credential" }
      response_result = JSON(response.body)
      response = Weixin.conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{response_result['access_token']}"
        req.body =  "{ \"touser\":\"#{resume.supplier.weixin_name}\", \"template_id\":\"wQ3FG81wTdwJXms-HCy_4L_56lIq9z2Zj-gOxv-Gw24\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"#{resume.supplier.email}, 您好\",
      \"color\":\"#173177\"
      },
      \"keyword1\":{
      \"value\":\"#{resume.candidate_name}的简历\",
      \"color\":\"#173177\"
      },
      \"keyword2\":{
      \"value\":\"通过\",
      \"color\":\"#173177\"
      },
      \"remark\":{
      \"value\":\"感谢您的推荐，如用户查看您的简历或者被推荐人成功入职，您都会得到相应的红包奖励。\",
      \"color\":\"#173177\"
      }}}"

      end
       response_result = JSON(response.body)
    end

    def notify_resume_paid(delivery)
      # {{first.DATA}}
      # 变动金额：{{keyword1.DATA}}
      # 变动时间：{{keyword2.DATA}}
      # {{remark.DATA}}
      response = Weixin.conn.get '/cgi-bin/token', { :appid => Weixin.mp_appid, :secret => Weixin.mp_secret, :grant_type => "client_credential" }
      response_result = JSON(response.body)
      response = Weixin.conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{response_result['access_token']}"
        req.body =  "{ \"touser\":\"#{delivery.resume.supplier.weixin_name}\", \"template_id\":\"N7X9PhMz8Ezgj_6mXBu_zJOVlvvCZlYq4JV3Uxl3eGA\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"#{delivery.resume.supplier.email}, 您好！您的简历库中的 #{delivery.resume.candidate_name}的简历被查看，您因此获得的红包：\",
      \"color\":\"#173177\"
      },
      \"keyword1\":{
      \"value\":\"#{delivery.job.bonus_for_each_resume}\",
      \"color\":\"#173177\"
      },
      \"keyword2\":{
      \"value\":\"#{Time.now.localtime.to_s(:db)}\",
      \"color\":\"#173177\"
      },
      \"remark\":{
      \"value\":\"您可以随时登录众聘达人领取。感谢您的推荐。\",
      \"color\":\"#173177\"
      }}}"
      end
       response_result = JSON(response.body)
    end

    def notify_resume_refused(delivery)
      response = Weixin.conn.get '/cgi-bin/token', { :appid => Weixin.mp_appid, :secret => Weixin.mp_secret, :grant_type => "client_credential" }
      response_result = JSON(response.body)
      response = Weixin.conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{response_result['access_token']}"
        req.body =  "{ \"touser\":\"#{delivery.resume.supplier.weixin_name}\", \"template_id\":\"N7X9PhMz8Ezgj_6mXBu_zJOVlvvCZlYq4JV3Uxl3eGA\", \"url\":\"http://#{Setting.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"#{delivery.resume.supplier.email}, 您好！您推荐的#{delivery.resume.candidate_name},被#{delivery.job.title}拒绝\",
      \"color\":\"#173177\"
      },
      \"keyword2\":{
      \"value\":\"#{Time.now.localtime.to_s(:db)}\",
      \"color\":\"#173177\"
      },
      \"remark\":{
      \"value\":\"详情您可以随时登录众聘达人查看。感谢您的推荐。\",
      \"color\":\"#173177\"
      }}}"
      end
    end

    private
    def mp_config
      YAML.load_file("#{Rails.root}/config/wechat.yml")["mp"]
    end
  end
end
