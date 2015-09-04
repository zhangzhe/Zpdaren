class Suppliers::JobsController < ApplicationController
  layout "suppliers"

  def index
    @jobs = Job.approved
  end
end
