class Suppliers::UsersController < ApplicationController
  layout 'suppliers'

  def show
    @supplier = Supplier.find(params[:id])
  end
end