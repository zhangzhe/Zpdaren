class PassthroughController < ApplicationController
  include DeviseHelper

  def index
    redirect_path = case current_user
    when Admin
      admins_jobs_path(:state => "max_priority")
    when Recruiter
      recruiters_jobs_path
    when Supplier
      suppliers_jobs_path(:state => "max_priority")
    else
      home_path
    end
    redirect_to redirect_path
  end
end
