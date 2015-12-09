module Statistics
  def today_added_count
    data_count(Date.today)
  end

  def yesterday_added_count
    data_count(1.day.ago)
  end

  def the_day_before_yesterday_added_count
    data_count(2.day.ago)
  end

  def Statistics.delivery_rate(scope = 'all')
    if scope == 'all'
      (Job.count == 0) ? 0 : (Job.has_approved_delivery.count.to_f / Job.count)
    else
      (Job.max_priority.count == 0) ? 0 : (Job.max_priority.has_approved_delivery.count.to_f / Job.max_priority.count)
    end
  end

  def Statistics.success_delivery_rate(scope = 'all')
    if scope == 'all'
      (Delivery.count == 0) ? 0 : (Delivery.after_paid.count.to_f / Delivery.count)
    else
      (Delivery.max_priority.count == 0) ? 0 : (Delivery.max_priority.after_paid.count.to_f / Delivery.max_priority.count)
    end

  end

  def self.supplier_attent_weixin_rate(scope = 'all')
    (Supplier.count == 0) ? 0 : (Weixin.joins(:user).count.to_f / Supplier.count)
  end

  def Statistics.active_supplier_rate(scope = 'all')
    (Supplier.count == 0) ? 0 : (Resume.active_suppliers_count.to_f / Supplier.count)
  end

  def Statistics.active_suppliers_this_week
    (Supplier.count == 0) ? 0 : Supplier.active_supplier_count_this_week
  end

  private
  def data_count(date)
    self.where(:created_at => (date.beginning_of_day..date.end_of_day)).count
  end
end
