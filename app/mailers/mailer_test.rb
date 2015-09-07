class MailerTest < ActionMailer::Base
  default :from => "gary.zzhang@hellohuohua.com"

  def test_1
    @password = "787664"
    mail(:to => "gary.zzhang@gmail.com",
         :subject => 'Password Reset Notification')
  end
end
