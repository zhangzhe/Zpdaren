class Recruiters::CompaniesController < Recruiters::BaseController
  def edit
    @company = current_recruiter.company
  end

  def update
    @company = current_recruiter.company
    if @company.update_attributes(company_params)
      redirect_to recruiters_jobs_path
    else
      flash[:error] = @company.errors.messages.values.first.first
      render 'edit' and return
    end
  end

  private
  def company_params
    params[:company].permit(:name, :description, :mobile, :address)
  end
end
