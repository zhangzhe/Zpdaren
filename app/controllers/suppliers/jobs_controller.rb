class Suppliers::JobsController < ApplicationController
  layout "suppliers"

  def index
    @jobs = Job.approved
  end

  def watch
    job = Job.find(params[:id])
    current_supplier.watch!(job)
    redirect_to :back
  end
end
