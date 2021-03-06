class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  private

  def delivery_options(from)
    {
      user_name: from.user_name,
      password: from.password,
      address: Settings.email.address,
      port: Settings.email.port,
      authentication: Settings.email.authentication.to_sym
    }
  end

  def embed_logo
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
  end
end
