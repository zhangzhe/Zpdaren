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
    return 0 if Job.count == 0

    if scope == 'all'
      had_delivery_jobs(scope).count.to_f / Job.count
    else
      had_delivery_jobs(scope).count.to_f / Job.high_priority.count
    end
  end

  def Statistics.success_delivery_rate(scope = 'all')
    return 0 if Delivery.count == 0

    if scope == 'all'
      Delivery.after_paid.count.to_f / Delivery.count
    else
      deliveries_for_high_priority_jobs.after_paid.count.to_f / deliveries_for_high_priority_jobs.count
    end
  end

  def self.supplier_attent_weixin_rate(scope = 'all')
    (Supplier.count == 0) ? 0 : (Weixin.joins(:user).count.to_f / Supplier.count)
  end

  def Statistics.active_supplier_rate(scope = 'all')
    (Supplier.count == 0) ? 0 : (Resume.active_suppliers_count.to_f / Supplier.count)
  end

  def Statistics.active_suppliers_recently_seven_days
    (Supplier.count == 0) ? 0 : Supplier.active_supplier_count_recently_seven_days
  end

  def Statistics.newly_active_suppliers_recently_seven_days
    (Supplier.count == 0) ? 0 : Supplier.newly_active_supplier_count_recently_seven_days
  end

  def self.deliveries_for_high_priority_jobs
    Delivery.joins(:job).where("priority = ?", Job::PRIORITY_LIST['high'])
  end

  def self.suppliers_for_high_priority_jobs
    Delivery.joins(:job, :resume).where("priority = ?", Job::PRIORITY_LIST['high']).select('supplier_id').distinct
  end

  private
  def data_count(date)
    self.where(:created_at => (date.beginning_of_day..date.end_of_day)).count
  end

  def self.had_delivery_jobs(scope)
    jobs = Job.joins(:deliveries)
    jobs = jobs.high_priority if scope == 'high_priority'
    jobs.distinct
  end
end
