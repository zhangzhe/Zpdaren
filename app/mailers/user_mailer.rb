class UserMailer < ApplicationMailer
  default :from => "xiaohua@hellohuohua.com"

  def welcome_email(user)
      @user = user
      @url  = "http://example.com/login"
      mail(:to => "gary.zzhang@hellohuohua.com", :subject => "Welcome to My Awesome Site")
    end
end
