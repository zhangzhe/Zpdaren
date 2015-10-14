class Authentication::Recruiters::PasswordsController < Devise::PasswordsController
  include PasswordForgetable
  include AuthenticationPathable
end
