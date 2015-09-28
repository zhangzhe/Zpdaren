class Authentication::Suppliers::SessionsController < Devise::SessionsController
  include AuthenticationPathable

end
