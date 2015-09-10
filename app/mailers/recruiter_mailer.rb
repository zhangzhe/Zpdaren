class RecruiterMailer < ApplicationMailer
  default :from => "xiaohua@hellohuohua.com"

  def email_jd_approved(recruiter)
    @recruiter = recruiter
    mail(:to => @recruiter.email, :subject => "您的招聘信息已经成功发布")
  end

  def email_resume_recommended(recruiter, resume, job)
    @recruiter = recruiter
    @resume = resume
    @job = job
    mail(:to => @recruiter.email, :subject => "您在Epin有新的简历推荐")
  end
end
