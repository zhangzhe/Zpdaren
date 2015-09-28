class Authentication::Recruiters::SessionsController < Devise::SessionsController

  private
  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/sessions/#{params[:action]}"
    super(*(args << options))
  end
end
