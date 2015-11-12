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

  def current_admin
    current_user if current_user.is_a?(Admin)
  end

  def  current_recruiter
    current_user if current_user.is_a?(Recruiter)
  end

  def  current_supplier
    current_user if current_user.is_a?(Supplier)
  end
end
