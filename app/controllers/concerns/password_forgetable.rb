module PasswordForgetable
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash[:alert] = '邮箱输入有误，请从新输入'
      redirect_path = eval("new_#{resource_name}_password_path")
      redirect_to redirect_path
    end
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    eval("new_#{resource_name}_session_path")
  end
end
