class Authentication::Suppliers::PasswordsController < Devise::PasswordsController
  include PasswordForgetable
  include AuthenticationPathable
end
