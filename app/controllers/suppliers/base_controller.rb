class Suppliers::BaseController < ApplicationController
  layout 'suppliers'
  before_action :default_sort, only: [:index]

  def show
  end

  private
  def default_sort
    params[:sort] ||= 'created_at'
    params[:direction] ||= 'DESC'
  end
end
