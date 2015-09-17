class Suppliers::BaseController < ApplicationController
  layout 'suppliers'

  def show
    render :text => "suppliers"
  end
end
