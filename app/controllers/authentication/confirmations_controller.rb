class Authentication::ConfirmationsController < Devise::ConfirmationsController
  def show
    if self.resource = User.find_by_confirmation_token(params[:confirmation_token]).confirmed_at?
      flash[:success] = '已经确认，请重新登录.'
      redirect_to new_user_session_path
    else
      if resource.errors.empty?
        set_flash_message(:notice, :confirmed) if is_flashing_format?
        respond_with_navigational(resource){ redirect_to new_user_session_path }
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){ redirect_to new_user_session_path }
      end
    end
  end
end
