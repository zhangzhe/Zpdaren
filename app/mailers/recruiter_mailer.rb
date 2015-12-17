class RecruiterMailer < ApplicationMailer

  def job_approved(recruiter, job)
    @recruiter = recruiter
    @job = job
    i = 0
    begin
      from = Settings.email.accounts[i]
      mail(:from => "#{Settings.email.sender}<#{from.user_name}>", to: recruiter.email, subject: "招聘信息成功发布【众聘】", :template_path => "notifications" , :template_name => "job_approved", delivery_method_options: delivery_options(from))
    rescue Net::SMTPFatalError
      i += 1
      retry if i < Settings.email.accounts.size
    end
  end

  def resume_recommended(recruiter, delivery)
    @recruiter = recruiter
    @delivery = delivery
    i = 0
    begin
      from = Settings.email.accounts[i]
      mail(:from => "#{Settings.email.sender}<#{from.user_name}>", to: recruiter.email, subject: "新的简历推荐【众聘】", :template_path => "notifications" , :template_name => "resume_recommended", delivery_method_options: delivery_options(from))
    rescue Net::SMTPFatalError
      i += 1
      retry if i < Settings.email.accounts.size
    end
  end

  def job_updated(job)
    @job = job
    i = 0
    begin
      from = Settings.email.accounts[i]
      mail(:from => "#{Settings.email.sender}<#{from.user_name}>", to: job.recruiter.email, subject: "招聘信息为您做出微调并成功发布【众聘】", :template_path => "notifications" , :template_name => "job_updated", delivery_method_options: delivery_options(from))
    rescue Net::SMTPFatalError
      i += 1
      retry if i < Settings.email.accounts.size
    end
  end
end
