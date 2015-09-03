class Recruiters::ResumesController < Admins::BaseController
  layout "recruiters"

  def index
    @resumes = Resume.active
  end

  def show
    @resume = Resume.find(params[:id])
  end
end
