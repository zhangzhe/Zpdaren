module AuthenticationPathable
  # for validate failure render page
  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/#{controller_name}/#{params[:action]}"
    super(*(args << options))
  end

  def after_sign_up_path_for(resource)
    session[:previous_url] || super
  end
end
