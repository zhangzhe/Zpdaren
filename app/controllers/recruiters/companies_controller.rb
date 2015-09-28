class Recruiters::CompaniesController < Recruiters::BaseController
  def edit
    @company = current_recruiter.company
  end

  def update
    @company = Company.update(params[:id], company_params)
    if @company.errors.any?
      flash[:error] = @company.errors.messages.values.first.first
      render 'edit' and return
    else
      redirect_to recruiters_path(@company)
    end
  end

  private
  def company_params
    params[:company].permit(:name, :description)
  end
end
