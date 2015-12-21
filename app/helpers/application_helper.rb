module ApplicationHelper

  def current_user_account_path
    case
    when current_recruiter
      recruiters_path
    when current_supplier
      suppliers_path
    else
      ""
    end
  end

  def front_page?
    params[:controller] == "home" && params[:action] == "index"
  end

  def active_for?(current_controllers)
    current_controllers.include?(controller.class) ? "active" : ""
  end

  def badge_for_admin(entity)
    " <span class=\"badge\">#{entity.count}</span>"
  end

  def badge_for_recruiter_jobs(recruiter)
    " <span class=\"badge\">#{recruiter.in_hiring_jobs_count}/#{recruiter.jobs_count}</span>" if (recruiter.jobs_count > 0)
  end

  def badge_for_recruiter_resumes(recruiter)
    " <span class=\"badge\">#{recruiter.unprocess_deliveries_count}/#{recruiter.recruiter_watchable_resumes_count}</span>" if (recruiter.recruiter_watchable_resumes_count > 0)
  end

  def external_url(url)
    (url.start_with?('http://') || url.start_with?('https://')) ? url : ('http://' + url)
  end

  def refused?(state)
    ['refused', 'recruiter_refused', 'admin_refused'].include?(state)
  end
end
