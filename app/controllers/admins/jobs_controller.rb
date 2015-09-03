class Admins::JobsController < Admins::BaseController

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end
end
