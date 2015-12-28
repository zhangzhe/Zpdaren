class Admins::CompaniesController < Admins::BaseController

  def show
    @company = Company.find(params[:id])
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    @company.attributes = company_params
    if @company.save
      redirect_to admins_company_path(@company)
    else
      flash[:error] = @company.errors.full_messages.first
      render 'edit' and return
    end
  end

  def service_protocol
    company = Company.find(params[:id])
    send_file company.service_protocol.current_path
  end

  private
  def company_params
    params[:company].permit(:name, :description, :mobile, :address, :url)
  end
end
