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

  def admin_page?
    true if params[:controller] =~ /^admins\//
  end

  def active_for?(current_controllers)
    current_controllers.include?(controller.class) ? "active" : ""
  end

  def badge_for_admin(entity)
    " <span class=\"badge\">#{entity.count}</span>"
  end

  def external_url(url)
    (url.start_with?('http://') || url.start_with?('https://')) ? url : ('http://' + url)
  end

  def refused?(state)
    ['refused', 'recruiter_refused', 'admin_refused'].include?(state)
  end
end
