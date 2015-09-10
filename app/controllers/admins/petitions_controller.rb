class Admins::PetitionsController < ApplicationController
  layout 'admins'

  def index
    @petitions = Petition.all
  end

  def show
    @petition = Petition.find(params[:id])
  end

  def agree
    petition = Petition.find(params[:id])
    petition.agree!
    petition.job.freeze!
    redirect_to admins_petitions_path
  end

  def refuse
    petition = Petition.find(params[:id])
    petition.refuse!
    redirect_to admins_petitions_path
  end
end