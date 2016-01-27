class Recruiters::CompaniesController < Recruiters::BaseController
  skip_filter :complete_company_info

  def edit
    @company = current_recruiter.company
  end

  def update
    @company = current_recruiter.company
    if @company.update_attributes(company_params)
      redirect_to recruiters_jobs_path
    else
      flash.now[:error] = @company.errors.full_messages.first
      render 'edit' and return
    end
  end

  def service_protocol
    company = Company.find(params[:id])
    send_file company.service_protocol.current_path
  end

  private
  def company_params
    params[:company].permit(:name, :description, :mobile, :address, :url, :service_protocol)
  end
end
