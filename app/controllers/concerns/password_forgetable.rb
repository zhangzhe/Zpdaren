module PasswordForgetable
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash[:alert] = '请输入正确的邮箱地址'
      redirect_to :back
    end
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    home_path
  end
end
