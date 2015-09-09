class Suppliers::DeliveriesController < ApplicationController
  layout 'suppliers'
  def new
    @job = Job.find(params[:job_id])
    @resumes = current_supplier.resumes
  end

  def create
    Delivery.create!(delivery_params)
    redirect_to suppliers_job_path(id: params[:delivery][:job_id])
  end

  private

  def delivery_params
    params.require(:delivery).permit(:job_id, :resume_id)
  end
end