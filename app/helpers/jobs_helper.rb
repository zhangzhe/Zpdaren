module JobsHelper

  def all_kinds_of_deliveries_count(job)
    label = ''
    class_css = ''
    job.all_kinds_of_deliveries_count.map do |k, v|
      case k.to_sym
      when :all_count
        class_css = 'label label-info'
      when :after_approved_count
        class_css = 'label label-primary'
      when :after_paid_count
        class_css = 'label label-success'
      when :refused_count
        class_css = 'label label-danger'
      end
      label += "<span class='#{class_css}'>#{v}</span>&nbsp;"
    end
    sanitize label
  end
end