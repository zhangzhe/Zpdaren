module WeixinNotification
  def send_subscribe_notification_to(subscribe_user)
    message = {
      touser: subscribe_user.user_name,
      msgtype: 'text',
      text: { content: '您好，欢迎关注众聘达人！' }
    }
    response = conn.post do |req|
      req.url "/cgi-bin/message/custom/send?access_token=#{access_token}"
      req.body = message.to_json
    end
  end

  def send_resume_refused_notification(delivery)
    template_id = "N7X9PhMz8Ezgj_6mXBu_zJOVlvvCZlYq4JV3Uxl3eGA"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://#{Settings.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name},被#{delivery.job_title}拒绝\",
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

  # {{first.DATA}}
  # 变动金额：{{keyword1.DATA}}
  # 变动时间：{{keyword2.DATA}}
  # {{remark.DATA}}
  def notify_resume_approved(resume)
    template_id = "wQ3FG81wTdwJXms-HCy_4L_56lIq9z2Zj-gOxv-Gw24"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{resume.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
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
    JSON(response.body)
  end

  # {{first.DATA}}
  # 变动金额：{{keyword1.DATA}}
  # 变动时间：{{keyword2.DATA}}
  # {{remark.DATA}}
  def notify_supplier_deposit_paid(resume, job)
    template_id = "N7X9PhMz8Ezgj_6mXBu_zJOVlvvCZlYq4JV3Uxl3eGA"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{resume.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"#{resume.supplier.email}, 您好！您的简历库中的 #{resume.candidate_name}的简历被查看，您因此获得的红包：\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{job.bonus_for_each_resume}\",
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
    JSON(response.body)
  end

  # {{first.DATA}}
  # 变动金额：{{keyword1.DATA}}
  # 变动时间：{{keyword2.DATA}}
  # {{remark.DATA}}
  def notify_supplier_final_payment_paid(resume, job)
    template_id = "N7X9PhMz8Ezgj_6mXBu_zJOVlvvCZlYq4JV3Uxl3eGA"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{resume.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"#{resume.supplier.email}, 您好！您推荐的 #{resume.candidate_name}以成功入职，您因此获得的红包：\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{job.bonus_for_entry}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{Time.now.localtime.to_s(:db)}\",
    \"color\":\"#173177\"
    },
    \"remark\":{
    \"value\":\"您可以随时登录众聘达人领取。再次感谢您的推荐！\",
    \"color\":\"#173177\"
    }}}"
    end
    JSON(response.body)
  end

  private
  def access_token
    response = conn.get '/cgi-bin/token', { :appid => appid, :secret => secret, :grant_type => "client_credential" }
    JSON(response.body)['access_token']
  end

  def weixin_config
    YAML.load_file("#{Rails.root}/config/weixin.yml")["mp"]
  end

  def appid
    weixin_config["appid"]
  end

  def secret
    weixin_config["secret"]
  end

  def conn
    Faraday.new(:url => weixin_config["url"])
  end
end
