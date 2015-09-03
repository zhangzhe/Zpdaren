class Suppliers::JobsController < ApplicationController
  layout "suppliers"

  def index
    @jobs = Job.all
  end
end
