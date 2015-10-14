class Authentication::Suppliers::PasswordsController < Devise::PasswordsController
  include PasswordForgetable
end
