class Authentication::Suppliers::ConfirmationsController < Devise::ConfirmationsController
  include AuthenticationPathable

  def show
    if Supplier.find_by_confirmation_token(params[:confirmation_token]).confirmed_at.nil?
      super
    else
      redirect_to new_supplier_session_path
    end
  end
end
