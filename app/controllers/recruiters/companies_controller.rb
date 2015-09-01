class Recruiters::CompaniesController < ApplicationController
  layout "recruiters"
  def edit
    @company = current_recruiter.company
  end

  def update
    @company = Company.update(params[:id], company_params)
    redirect_to recruiters_company_path(@company)
  end

  def show
    @company = Company.find(params[:id])
  end

  private
  def company_params
    params[:company].permit(:name, :description)
  end
end
