module WeixinApi
  module Notification
    def subscribe(id)
      subscribe_user = weixin.find(id)
      message = {
        touser: subscribe_user.user_name,
        msgtype: 'text',
        text: { content: '您好，欢迎关注众聘达人-火花！火花是众聘达人平台（zpdaren.com）专为推荐方定制的服务号。推荐优质简历，获得企业悬赏！此服务号将用于您每一次推荐的关键通知。' }
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
    def delivery_refused(id)
      delivery = Delivery.find(id)
      template_id = "D8iifbTdXyl__XGNpOF_3FItm5y8vpauWptkADXciVQ"
      response = conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
        req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://#{Settings.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name}被拒绝\",
      \"color\":\"#173177\"
      },
      \"keyword1\":{
      \"value\":\"#{delivery.company_name}\",
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
    def delivery_approved(id)
      delivery = Delivery.find(id)
      template_id = "D8iifbTdXyl__XGNpOF_3FItm5y8vpauWptkADXciVQ"
      response = conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
        req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://#{Settings.domain.host}\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name}审核通过\",
      \"color\":\"#173177\"
      },
      \"keyword1\":{
      \"value\":\"#{delivery.company_name}\",
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
    def delivery_paid(id)
      delivery = Delivery.find(id)
      template_id = "WIOViJ34e8OnSrLVHfR8slRFbt0pybhBehx4jm2VhfM"
      response = conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{access_token}"
        req.body =  "{ \"touser\":\"#{delivery.supplier.weixin_name}\", \"template_id\":\"#{template_id}\", \"url\":\"http://weixin.qq.com/download\",\"topcolor\":\"#FF0000\", \"data\": {
      \"first\": {
      \"value\":\"尊敬的用户#{delivery.supplier.email}, 您好！您推荐的#{delivery.resume_candidate_name}的简历被查看，获得了简历红包：\",
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
      \"keyword3\":{
      \"value\":\"#{delivery.resume_candidate_name}\",
      \"color\":\"#173177\"
      },
      \"keyword4\":{
      \"value\":\"#{delivery.job.bonus_for_each_resume_for_supplier}元\",
      \"color\":\"#173177\"
      },
      \"keyword5\":{
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

    # {{first.DATA}}
    # 变动金额：{{keyword1.DATA}}
    # 变动时间：{{keyword2.DATA}}
    # {{remark.DATA}}
    def delivery_final_payment_paid(id)
      delivery = Delivery.find(id)
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
      \"keyword3\":{
      \"value\":\"#{delivery.resume_candidate_name}\",
      \"color\":\"#173177\"
      },
      \"keyword4\":{
      \"value\":\"#{delivery.final_payment.amount}元\",
      \"color\":\"#173177\"
      },
      \"keyword5\":{
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
  end
end

