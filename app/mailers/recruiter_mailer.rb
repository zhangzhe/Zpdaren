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
                  此邮件由众聘达人系统发出，系统不接收回信，请勿直接回复。
                </p>"
        render html: html.html_safe
      end
    end
  end

  def email_resume_recommended(recruiter, delivery)
    mail(:to => recruiter.email, :subject => "您在众聘达人有新的简历推荐") do |format|
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
                  此邮件由众聘达人系统发出，系统不接收回信，请勿直接回复。
                </p>"
        render html: html.html_safe
      end
    end
  end

  def edit_job_notify(job)
    mail(:to => job.recruiter.email, :subject => "众聘达人职位修改通知") do |format|
      format.html do
        html = "<p>
                  <h3>
                    尊敬的：#{job.recruiter.email}
                  </h3>
                </p>
                <p style=\"text-indent:2em;\">
                系统对您发布的职位<a href=\"http://#{Settings.domain.host}:#{Settings.domain.port}/recruiters/jobs/#{job.id}\">#{job.title}</a>中不符合标准的内容进行了修改，请登录众聘达人查看详情。
                </p>
                <p style=\"color: gray;\">
                  此邮件由众聘达人系统发出，系统不接收回信，请勿直接回复。
                </p>"
        render html: html.html_safe
      end
    end
  end
end
