module PasswordForgetable
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      respond_with({}, location: login_path_for(resource_name))
    else
      flash[:alert] = '邮箱输入有误，请从新输入'
      redirect_to forget_password_path_for(resource_name)
    end
  end
end
