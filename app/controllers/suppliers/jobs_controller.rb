class Suppliers::JobsController < ApplicationController
  layout "suppliers"

  def index
    @jobs = Job.approved
  end

  def attend
    job = Job.find(params[:id])
    current_supplier.attend(job)
    redirect_to :back
  end
end
