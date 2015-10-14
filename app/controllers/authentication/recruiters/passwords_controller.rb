class Authentication::Recruiters::PasswordsController < Devise::PasswordsController
  include PasswordForgetable
end
