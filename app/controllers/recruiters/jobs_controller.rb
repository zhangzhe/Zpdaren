class Recruiters::JobsController < ApplicationController
  def index
    if current_recruiter.company.description.blank?
      redirect_to recruiters_companies_edit_path
    end
  end
end
