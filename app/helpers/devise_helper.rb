module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert fade in alert-danger">
      <button class="close" data-dismiss="alert">&times;</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  def signed_in?
    current_user
  end

  def current_user
    current_admin || current_recruiter || current_supplier
  end
end
