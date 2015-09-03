class Admins::CompaniesController < Admins::BaseController

  def index
    @companies = Company.active
  end

  def show
    @company = Company.find(params[:id])
  end
end
