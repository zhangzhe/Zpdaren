class Authentication::Suppliers::ConfirmationsController < Devise::ConfirmationsController

  private
  def render(*args)
    options = args.extract_options!
    options[:template] = "/authentication/confirmations/#{params[:action]}"
    super(*(args << options))
  end
end
