ActionMailer::Base.smtp_settings = {
  :address        => Settings.email.address, # default: localhost
  :port           => Settings.email.port,                  # default: 25
  :user_name      => Settings.email.default_account.user_name,
  :password       => Settings.email.default_account.password,
  :authentication => Settings.email.authentication.to_sym    # :plain, :login or :cram_md5
}
