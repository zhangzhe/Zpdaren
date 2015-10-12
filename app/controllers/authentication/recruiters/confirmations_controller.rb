class Authentication::Recruiters::ConfirmationsController < Devise::ConfirmationsController
  include AuthenticationPathable

  def show
    if Recruiter.find_by_confirmation_token(params[:confirmation_token]).confirmed_at.present?
      flash[:success] = '已经确认，请重新登录.'
      redirect_to new_recruiter_session_path
    else
      super
    end
  end
end
