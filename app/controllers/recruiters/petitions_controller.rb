class Recruiters::PetitionsController < ApplicationController
  layout 'recruiters'

  def index
    @petitions = current_recruiter.petitions
  end

  def new
    @job = Job.find(params[:job_id])
  end

  def create
    current_recruiter.petitions.create!(petition_params)
    redirect_to recruiters_petitions_path
  end

  private
  def petition_params
    params.require(:petition).permit!
  end
end