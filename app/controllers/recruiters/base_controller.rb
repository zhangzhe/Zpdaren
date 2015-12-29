class Recruiters::BaseController < ApplicationController
  layout 'recruiters'

  before_action :complete_company_info

  # 账户管理
  def show
  end

  private

  def complete_company_info
    unless current_recruiter.company.info_completed?
      flash[:notice] = "请先完善公司信息，然后再发布职位"
      redirect_to edit_recruiters_company_path(current_recruiter.company) and return
    end
  end
end
