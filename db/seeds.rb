Admin.create!(:email => "admin@admin.com", :password => "admin@admin.com", :password_confirmation => "admin@admin.com")

supplier = Supplier.create!(:email => "supplier@supplier.com", :password => "supplier@supplier.com", :password_confirmation => "supplier@supplier.com", :confirmation_token => "kigGUkyxqxZmiRHyXzs-", :confirmed_at => "2015-09-17 06:20:10", :confirmation_sent_at => "2015-09-17 06:19:04")

supplier.create_weixin(:user_name => "oQluvt9GRkr6jZeMyNC7sYnI_iVA")

Recruiter.create!(:email => "recruiter@recruiter.com", :password => "recruiter@recruiter.com", :password_confirmation => "recruiter@recruiter.com", :confirmation_token => "kigGUkyxqxZmiRHyXzs-", :confirmed_at => "2015-09-17 06:20:10", :confirmation_sent_at => "2015-09-17 06:19:04")

Recruiter.create!(:email => "gary.zzhang@hellohuohua.com", :password => "gary.zzhang@hellohuohua.com", :password_confirmation => "gary.zzhang@hellohuohua.com", :confirmation_token => "kigGUkyxqxZmiRHyXzs-", :confirmed_at => "2015-09-17 06:20:10", :confirmation_sent_at => "2015-09-17 06:19:04")
