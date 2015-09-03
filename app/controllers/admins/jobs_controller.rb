class Admins::JobsController < ApplicationController
  layout 'admins'

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end
end
