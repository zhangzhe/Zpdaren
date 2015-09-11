class Recruiters::RefundRequestsController < Recruiters::BaseController

  def index
    @refund_requests = current_recruiter.jobs.map(&:refund_requests).flatten!
  end

  def new
    @job = Job.find(params[:job_id])
  end

  def create
    RefundRequest.create!(refund_request_params)
    redirect_to recruiters_refund_requests_path
  end

  private
  def refund_request_params
    params.require(:refund_request).permit!
  end
end
