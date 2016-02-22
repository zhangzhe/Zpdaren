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
      flash.now[:error] = @company.errors.full_messages.first
      render 'edit'
    end
  end

  def service_protocol
    company = Company.find(params[:id])
    send_file company.service_protocol.current_path
  end

  def export
    @companies = Company.all
    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="招聘方列表.xlsx"'
      }
    end
  end

  private
  def company_params
    params[:company].permit(:name, :description, :mobile, :address, :url)
  end
end
