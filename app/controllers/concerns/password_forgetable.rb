module PasswordForgetable
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash[:alert] = '请输入正确的邮箱地址'
      redirect_to :back
    end
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    home_path
  end

  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/#{controller_name}/#{params[:action]}"
    super(*(args << options))
  end
end