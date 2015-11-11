class Authentication::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      respond_with({}, location: forget_password_redirection_path)
    else
      flash[:alert] = '邮箱输入有误，请重新输入'
      redirect_to forget_password_path_for(resource_name)
    end
  end
end
