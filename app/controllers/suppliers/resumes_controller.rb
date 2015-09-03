class Suppliers::ResumesController < ApplicationController
  layout "suppliers"

  def index
    @resumes = current_supplier.resumes
  end

end
