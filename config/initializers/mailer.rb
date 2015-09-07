ActionMailer::Base.smtp_settings = {
  :address        => "smtp.qq.com", # default: localhost
  :port           => '25',                  # default: 25
  :user_name      => "xiaohua@hellohuohua.com",
  :password       => "1234qwerQWER",
  :authentication => :plain                 # :plain, :login or :cram_md5
}

