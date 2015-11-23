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

  def Statistics.delivery_rate
     (Job.count == 0) ? 0 : Job.has_approved_delivery.count.to_f/Job.count
  end

  def Statistics.success_delivery_rate
    (Delivery.count == 0) ? 0 : Delivery.after_paid.count.to_f/Delivery.count
  end

  def Statistics.active_supplier_rate
    (Supplier.count == 0) ? 0 : (Resume.active_suppliers_count.to_f / Supplier.count)
  end

  private
  def data_count(date)
    self.where(:created_at => (date.beginning_of_day..date.end_of_day)).count
  end
end
