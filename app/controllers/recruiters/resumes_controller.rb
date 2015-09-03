class Recruiters::ResumesController < Admins::BaseController
  layout "recruiters"

  def index
    @resumes = Resume.active
  end
end
