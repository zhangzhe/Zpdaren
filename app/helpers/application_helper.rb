require 'redcarpet'
module ApplicationHelper

  ALLOW_TAGS = %w(p br img h1 h2 h3 h4 h5 h6 blockquote pre code b i
                  strong em table tr td tbody th strike del u a ul ol li span hr)
  ALLOW_ATTRIBUTES = %w(href src class id title alt target rel data-floor)
  EMPTY_STRING = ''.freeze

  def sanitize_markdown(body)
    # TODO: This method slow, 3.5ms per call in topic body
    sanitize body, tags: ALLOW_TAGS, attributes: ALLOW_ATTRIBUTES
  end

  # 去除区域里面的内容的换行标记
  def spaceless(&block)
    data = with_output_buffer(&block)
    data = data.gsub(/\n\s+/, EMPTY_STRING)
    data = data.gsub(/>\s+</, '><')
    sanitize data
  end

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

  def sortable(title, column)
    direction = (column == sort_column && sort_direction == "DESC") ? "ASC" : "DESC"
    link_to title, {:sort => column, :direction => direction}
  end

  def external_url(url)
    (url.start_with?('http://') || url.start_with?('https://')) ? url : ('http://' + url)
  end

  def refused?(state)
    ['refused', 'recruiter_refused', 'admin_refused'].include?(state)
  end
end
