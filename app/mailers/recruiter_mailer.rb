class RecruiterMailer < ApplicationMailer
  default :from => "xiaohua@hellohuohua.com"

  def job_approved(recruiter, job)
    @recruiter = recruiter
    @job = job
    mail(:to => recruiter.email, :subject => "招聘信息成功发布【众聘】", :template_path => "notifications" , :template_name => "job_approved")
  end

  def resume_recommended(recruiter, delivery)
    @recruiter = recruiter
    @delivery = delivery
    mail(:to => recruiter.email, :subject => "新的简历推荐【众聘】", :template_path => "notifications" , :template_name => "resume_recommended")
  end

  def job_updated(job)
    @job = job
    mail(:to => job.recruiter.email, :subject => "招聘信息为您做出微调并成功发布【众聘】", :template_path => "notifications" , :template_name => "job_updated")
  end
end
