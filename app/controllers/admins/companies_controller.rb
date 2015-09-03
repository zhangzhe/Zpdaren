class Admins::CompaniesController < ApplicationController
  layout 'admins'

  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end
end
