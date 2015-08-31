class Recruiters::JobsController < ApplicationController
  def index
    if current_recruiter.company.description.blank?
      redirect_to recruiters_companys_edit_path
    else

    end
  end
end
