Admin.create!(:email => "admin@admin.com", :password => "admin@admin.com", :password_confirmation => "admin@admin.com")

supplier = Supplier.create!(:email => "supplier@supplier.com", :password => "supplier@supplier.com", :password_confirmation => "supplier@supplier.com")

supplier.create_weixin(:user_name => "oQluvt9GRkr6jZeMyNC7sYnI_iVA")

Recruiter.create!(:email => "recruiter@recruiter.com", :password => "recruiter@recruiter.com", :password_confirmation => "recruiter@recruiter.com")

Recruiter.create!(:email => "gary.zzhang@hellohuohua.com", :password => "gary.zzhang@hellohuohua.com", :password_confirmation => "gary.zzhang@hellohuohua.com")