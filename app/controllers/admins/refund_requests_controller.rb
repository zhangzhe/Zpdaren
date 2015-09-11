class Admins::RefundRequestsController < Admins::BaseController

  def index
    @refund_requests = RefundRequest.all
  end

  def show
    @refund_request = RefundRequest.find(params[:id])
  end

  def agree
    refund_request = RefundRequest.find(params[:id])
    refund_request.agree!
    refund_request.job.freeze!
    redirect_to admins_refund_requests_path
  end

  def refuse
    refund_request = RefundRequest.find(params[:id])
    refund_request.refuse!
    redirect_to admins_refund_requests_path
  end
end