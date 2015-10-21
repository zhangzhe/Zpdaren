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

  def active_for?(current_controller)
    controller.class == current_controller ? "active" : ""
  end

  def badge_for_admin(entity)
    " <span class=\"badge\">#{entity.waiting_approved.count}</span>" if (entity.waiting_approved.count > 0)
  end

  def badge_for_recruiter_jobs(recruiter)
    " <span class=\"badge\">#{recruiter.in_hiring_jobs_count}/#{recruiter.jobs_count}</span>" if (recruiter.jobs_count > 0)
  end

  def badge_for_recruiter_resumes(recruiter)
    " <span class=\"badge\">#{recruiter.unprocess_deliveries_count}/#{recruiter.recruiter_watchable_resumes_count}</span>" if (recruiter.recruiter_watchable_resumes_count > 0)
  end

  def sortable(title, column)
    direction = (column == sort_column && sort_direction == "DESC") ? "ASC" : "DESC"
    link_to title, {:sort => column, :direction => direction}
  end
end
