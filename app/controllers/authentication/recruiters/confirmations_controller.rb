class Authentication::Recruiters::ConfirmationsController < Devise::ConfirmationsController
  include AuthenticationPathable

  def show
    if Recruiter.find_by_confirmation_token(params[:confirmation_token]).confirmed_at.nil?
      super
    else
      redirect_to new_recruiter_session_path
    end
  end
end
