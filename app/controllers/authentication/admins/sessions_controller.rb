class Authentication::Admins::SessionsController < Devise::SessionsController
  include AuthenticationPathable
end
