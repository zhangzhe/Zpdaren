module TestDataRecoverer
  def recover_recruiter
    recruiter = self
    ActiveRecord::Base.transaction do
      company.delete if company = Company.find_by_user_id(recruiter.id)
      jobs = Job.where("user_id = ?", recruiter.id)
      jobs.each do |job|
        recover_money(job)
        RefundRequest.where("job_id = ?", job.id).delete_all
        Watching.where("job_id = ?", job.id).delete_all
        Deposit.where('job_id = ?', job.id).delete_all
        deliveries = Delivery.where("job_id = ?", job.id)
        recover_deliveries(deliveries)
      end
      jobs.delete_all
      if wallet = Wallet.find_by_user_id(recruiter.id)
        Withdraw.where("wallet_id = ?", wallet.id).delete_all
        wallet.delete
      end
      recruiter.delete
    end
  end

  def recover_supplier
    supplier = self
    ActiveRecord::Base.transaction do
      resumes = Resume.where("supplier_id = ?", supplier.id)
      resumes.each do |resume|
        deliveries = Delivery.where("resume_id = ?", resume.id)
        recover_deliveries(deliveries)
      end
      resumes.delete_all
      if wallet = Wallet.find_by_user_id(supplier.id)
        Withdraw.where("wallet_id = ?", wallet.id).delete_all
        wallet.delete
      end
      if weixin = Weixin.find_by_user_id(supplier.id)
        weixin.delete
      end
      supplier.delete
    end
  end

  private
  def recover_money(job)
    if Deposit.find_by_job_id(job.id)
      admin = Admin.admin
      if job.deposit_paid? || job.deposit_paid_confirmed? || job.finished?
        admin.pay(job.deposit.to_i)
      elsif job.final_payment_paid?
        admin.pay(job.deposit.to_i + job.bonus_for_entry)
      end

      job.deliveries.each do |delivery|
        admin.pay(job.bonus_for_each_resume / 2) if ['paid', 'final_payment_paid', 'finished'].include?(delivery.state)
      end
    end
  end

  def recover_deliveries(deliveries)
    deliveries.each do |delivery|
      if rejection = Rejection.find_by_delivery_id(delivery.id)
        rejection.delete
      end
      if final_payment = FinalPayment.find_by_id(delivery.final_payment_id)
        final_payment.delete
      end
    end
    deliveries.delete_all
  end
end