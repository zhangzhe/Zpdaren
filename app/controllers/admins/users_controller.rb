class Admins::UsersController < Admins::BaseController

  def index
    @users = User.all
  end
end
