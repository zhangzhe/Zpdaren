module AuthenticationPathable

  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/#{controller_name}/#{params[:action]}"
    super(*(args << options))
  end
end
