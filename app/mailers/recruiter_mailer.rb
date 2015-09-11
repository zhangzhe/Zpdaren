class RecruiterMailer < ApplicationMailer
  default :from => "xiaohua@hellohuohua.com"

  def email_jd_approved(recruiter, job)
    mail(:to => recruiter.email, :subject => "您的招聘信息已经成功发布") do |format|
      format.html do
        html = "<p>
                  <h3>
                    尊敬的：#{recruiter.email}
                  </h3>
                </p>
                <p style=\"text-indent:2em;\">
                您发布的职位<a href=\"http://#{Settings.domain.host}:#{Settings.domain.port}/recruiters/jobs/#{job.id}\">#{job.title}</a>，已被管理员审核通过。
                </p>
                <p style=\"color: gray;\">
                  此邮件由e聘系统发出，系统不接收回信，请勿直接回复。
                </p>"
        render html: html.html_safe
      end
    end
  end

  def email_resume_recommended(recruiter, delivery)
    mail(:to => recruiter.email, :subject => "您在e聘有新的简历推荐") do |format|
      format.html do
        html = "<p>
                  <h3>
                    尊敬的：#{recruiter.email}
                  </h3>
                </p>
                <p style=\"text-indent:2em;\">
                您发布的职位<a href=\"http://#{Settings.domain.host}:#{Settings.domain.port}/recruiters/jobs/#{delivery.job_id}\">#{delivery.job_title}</a>，收到了简历投递，点击<a href=\"http://#{Settings.domain.host}:#{Settings.domain.port}/recruiters/deliveries/#{delivery.id}\">链接</a>查看简历。
                </p>
                <p style=\"color: gray;\">
                  此邮件由e聘系统发出，系统不接收回信，请勿直接回复。
                </p>"
        render html: html.html_safe
      end
    end
  end
end
