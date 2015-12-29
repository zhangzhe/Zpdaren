class InterviewsController < ActionController::Base
  layout 'anonymous_job'

  def show
    @interview = Interview.find(params[:id])
  end
end
