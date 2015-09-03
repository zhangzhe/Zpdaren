class Admins::UsersController < ApplicationController
  layout 'admins'
  def index
    @users = User.all
  end
end