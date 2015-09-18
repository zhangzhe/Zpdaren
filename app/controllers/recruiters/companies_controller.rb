class Recruiters::CompaniesController < Recruiters::BaseController
  def edit
    @company = current_recruiter.company
  end

  def update
    @company = Company.update(params[:id], company_params)
    redirect_to recruiters_path
  end

  private
  def company_params
    params[:company].permit(:name, :description)
  end
end
