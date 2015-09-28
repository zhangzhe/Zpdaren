class Authentication::Recruiters::PasswordsController < Devise::PasswordsController

  def after_sending_reset_password_instructions_path_for(resource_name)
    home_path
  end

  private
  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/passwords/#{params[:action]}"
    super(*(args << options))
  end
end
