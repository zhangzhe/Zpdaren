class Admins::CompaniesController < Admins::BaseController

  def show
    @company = Company.find(params[:id])
  end
end
