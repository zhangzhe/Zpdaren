class Recruiters::JobsController < ApplicationController
  layout "recruiters"

  def index
    if current_recruiter.company.description.blank?
      redirect_to edit_recruiters_company_path(current_recruiter.company)
    end
  end
end
