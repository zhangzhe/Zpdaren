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

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message(:notice, flash_message) if is_flashing_format?
        sign_in(resource_name, resource)
      else
        set_flash_message(:notice, :updated_not_active) if is_flashing_format?
      end
      redirect_to root_path
    else
      respond_with resource
    end
  end
end
