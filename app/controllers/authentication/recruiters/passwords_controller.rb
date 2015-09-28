class Authentication::Recruiters::PasswordsController < Devise::PasswordsController
  include AuthenticationPathable

  def after_sending_reset_password_instructions_path_for(resource_name)
    home_path
  end
end
