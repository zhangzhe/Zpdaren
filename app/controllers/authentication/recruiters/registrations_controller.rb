class Authentication::Recruiters::RegistrationsController < Devise::RegistrationsController

  private
  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/registrations/#{params[:action]}"
    super(*(args << options))
  end
end
