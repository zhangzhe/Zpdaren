module WeixinConnection
  def qrcode_url(ticket)
    "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ticket}"
  end

  def qr_code_ticket(scene_id)
    response = conn.post do |req|
      req.url "/cgi-bin/qrcode/create?access_token=#{access_token}"
      req.body = "{ \"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": { \"scene\": { \"scene_id\": #{scene_id} } } }"
    end
    response_result = JSON(response.body)
    response_result['ticket']
  end

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

  # {{first.DATA}}
  # 招聘方：{{keyword1.DATA}}
  # 职位：{{keyword2.DATA}}
  # 被推荐人：{{keyword3.DATA}}
  # 简历状态：{{keyword4.DATA}}
  # 时间：{{keyword5.DATA}}
  # {{remark.DATA}}
  def send_resume_refused_notification(delivery)
    template_id = "D8iifbTdXyl__XGNpOF_3FItm5y8vpauWptkADXciVQ"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://#{Settings.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name}被拒绝\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{delivery.job.company.name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.job_title}\",
    \"color\":\"#173177\"
    },
    \"keyword3\":{
    \"value\":\"#{delivery.resume_candidate_name}\",
    \"color\":\"#173177\"
    },
    \"keyword4\":{
    \"value\":\"拒绝\",
    \"color\":\"#173177\"
    },
    \"keyword5\":{
    \"value\":\"#{Time.now.strftime("%Y年%m月%d日 %H:%m")}\",
    \"color\":\"#173177\"
    },
    \"remark\":{
    \"value\":\"详情您可以随时登录众聘达人查看。感谢您的推荐。\",
    \"color\":\"#173177\"
    }}}"
    end
    JSON(response.body)
  end

  # {{first.DATA}}
  # 招聘方：{{keyword1.DATA}}
  # 职位：{{keyword2.DATA}}
  # 被推荐人：{{keyword3.DATA}}
  # 简历状态：{{keyword4.DATA}}
  # 时间：{{keyword5.DATA}}
  # {{remark.DATA}}
  def notify_resume_approved(delivery)
    template_id = "D8iifbTdXyl__XGNpOF_3FItm5y8vpauWptkADXciVQ"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://#{Settings.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name}审核通过\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{delivery.job.company.name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.job_title}\",
    \"color\":\"#173177\"
    },
    \"keyword3\":{
    \"value\":\"#{delivery.resume_candidate_name}\",
    \"color\":\"#173177\"
    },
    \"keyword4\":{
    \"value\":\"审核通过\",
    \"color\":\"#173177\"
    },
    \"keyword5\":{
    \"value\":\"#{Time.now.strftime("%Y年%m月%d日 %H:%m")}\",
    \"color\":\"#173177\"
    },
    \"remark\":{
    \"value\":\"详情您可以随时登录众聘达人查看。感谢您的推荐。\",
    \"color\":\"#173177\"
    }}}"
    end
    JSON(response.body)
  end

  # {{first.DATA}}
  # 招聘方：{{keyword1.DATA}}
  # 职位：{{keyword2.DATA}}
  # 被推荐人：{{keyword3.DATA}}
  # 奖励：{{keyword4.DATA}}
  # 时间：{{keyword5.DATA}}
  # {{remark.DATA}}
  def notify_supplier_deposit_paid(delivery)
    template_id = "WIOViJ34e8OnSrLVHfR8slRFbt0pybhBehx4jm2VhfM"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的 #{delivery.resume_candidate_name}的简历被查看，获得了简历红包：\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{delivery.job.company_name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.job_title}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.resume_candidate_name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.job.bonus_for_each_resume/2}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{Time.now.strftime("%Y年%m月%d日 %H:%m")}元\",
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
  def notify_supplier_final_payment_paid(delivery)
    template_id = "WIOViJ34e8OnSrLVHfR8slRFbt0pybhBehx4jm2VhfM"
    response = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
      req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
    \"first\": {
    \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的 #{delivery.resume_candidate_name}已成功入职，获得了入职红包：\",
    \"color\":\"#173177\"
    },
    \"keyword1\":{
    \"value\":\"#{delivery.job.company_name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.job_title}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.resume_candidate_name}\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{delivery.final_payment.amount}元\",
    \"color\":\"#173177\"
    },
    \"keyword2\":{
    \"value\":\"#{Time.now.strftime("%Y年%m月%d日 %H:%m")}\",
    \"color\":\"#173177\"
    },
    \"remark\":{
    \"value\":\"您可以随时登录众聘达人领取。感谢您的推荐。\",
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
