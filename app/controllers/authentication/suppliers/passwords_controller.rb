class Authentication::Suppliers::PasswordsController < Devise::PasswordsController

  def after_sending_reset_password_instructions_path_for(resource_name)
    home_path
  end

end
