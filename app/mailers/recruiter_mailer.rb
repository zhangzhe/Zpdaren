class RecruiterMailer < ApplicationMailer

  def job_approved(recruiter, job)
    @recruiter = recruiter
    @job = job
    subject = '招聘信息成功发布【众聘】'
    template_name = 'job_approved'
    send_mail(recruiter.email, subject, template_name)
  end

  def resume_recommended(recruiter, delivery)
    @recruiter = recruiter
    @delivery = delivery
    subject = '新的简历推荐【众聘】'
    template_name = 'resume_recommended'
    send_mail(recruiter.email, subject, template_name)
  end

  def job_updated(job)
    @job = job
    subject = '招聘信息为您做出微调并成功发布【众聘】'
    template_name = 'job_updated'
    send_mail(job.recruiter.email, subject, template_name)
  end

  private

  def send_mail(recipient, subject, template_name, template_path = 'notifications')
    embed_logo
    i = 0
    begin
      from = Settings.email.accounts[i]
      mail(:from => "#{Settings.email.sender}<#{from.user_name}>", to: recipient, subject: subject, :template_path => template_path , :template_name => template_name, delivery_method_options: delivery_options(from))
    rescue Net::SMTPFatalError
      i += 1
      retry if i < Settings.email.accounts.size
    end
  end
end
