class Authentication::Suppliers::RegistrationsController < Devise::RegistrationsController
  include AuthenticationPathable

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to signup_redirection_path
      end
    else
      flash[:alert] = resource.errors.full_messages.first
      redirect_to new_supplier_registration_path
    end
  end

  protected
  def after_inactive_sign_up_path_for(resource)
    new_supplier_session_path
  end
end
