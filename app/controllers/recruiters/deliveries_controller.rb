class Recruiters::DeliveriesController < ApplicationController
  layout "recruiters"

  def index
    @deliveries = []
    if params[:job_id]
      jobs = [Job.find(params[:job_id])]
    else
      jobs = current_recruiter.company.jobs
    end
    jobs.map do |job|
      @deliveries << job.deliveries unless job.deliveries.blank?
    end
    @deliveries.flatten!
  end

  def show
    @delivery = Delivery.find(params[:id])
  end

  def pay
    @delivery = Delivery.find(params[:id])
    @delivery.pay!
    redirect_to :back
  end
end
