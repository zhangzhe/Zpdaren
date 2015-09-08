class Suppliers::AttentionsController < ApplicationController

  def create
    Attention.create!(attention_params)
    redirect_to :back
  end

  private
  def attention_params
    params.require(:attention).permit(:job_id, :supplier_id)
  end
end