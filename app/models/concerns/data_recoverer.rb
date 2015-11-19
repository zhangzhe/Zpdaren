module DataRecoverer
  def recruiter_recover
    company.destroy if company = Company.find_by_user_id(self.id)
    jobs = Job.where("user_id = ?", self.id)
    jobs.each do |job|
      RefundRequest.where("job_id = ?", job.id).destroy_all
      Watching.where("job_id = ?", job.id).destroy_all
      Deposit.where('job_id = ?', job.id).destroy_all
      deliveries = Delivery.where("job_id = ?", job.id)
      deliveries_recover(deliveries)
    end
    jobs.destroy_all

    deleted_jobs = Job.only_deleted.where("user_id = ?", self.id)
    deleted_jobs.each do |deleted_job|
      RefundRequest.only_deleted.where("job_id = ?", deleted_job.id).destroy_all
      Watching.only_deleted.where("job_id = ?", deleted_job.id).destroy_all
      Deposit.only_deleted.where('job_id = ?', deleted_job.id).destroy_all
      deliveries = Delivery.only_deleted.where("job_id = ?", deleted_job.id)
      real_deliveries_recover(deliveries)
    end
    deleted_jobs.destroy_all

    if wallet = Wallet.find_by_user_id(self.id)
      Withdraw.where("wallet_id = ?", wallet.id).destroy_all
      wallet.destroy
    end
  end

  def supplier_recover
    resumes = Resume.where("supplier_id = ?", self.id)
    resumes.each do |resume|
      deliveries = Delivery.where("resume_id = ?", resume.id)
      deliveries_recover(deliveries)

      deleted_deliveries = Delivery.only_deleted.where("resume_id = ?", resume.id)
      real_deliveries_recover(deleted_deliveries)
    end
    resumes.destroy_all
    if wallet = Wallet.find_by_user_id(self.id)
      Withdraw.where("wallet_id = ?", wallet.id).destroy_all
      wallet.destroy
    end
    if weixin = Weixin.find_by_user_id(self.id)
      weixin.destroy
    end
  end

  def job_recover
    RefundRequest.where("job_id = ?", self.id).destroy_all
    Watching.where("job_id = ?", self.id).destroy_all
    Deposit.where('job_id = ?', self.id).destroy_all
    deliveries = Delivery.where("job_id = ?", self.id)
    deliveries_recover(deliveries)
  end

  def resume_recover
    ActiveRecord::Base.transaction do
      self.deliveries.each do |delivery|
        delivery.rejection.delete if delivery.rejection
        delivery.delete
      end
      self.delete
    end
    return true
  end

  private

  def deliveries_recover(deliveries)
    deliveries.each do |delivery|
      if rejection = Rejection.find_by_delivery_id(delivery.id)
        rejection.destroy
      end
      if final_payment = FinalPayment.find_by_id(delivery.final_payment_id)
        final_payment.destroy
      end
    end
    deliveries.destroy_all
  end

  def real_deliveries_recover(deliveries)
    deliveries.each do |delivery|
      if rejection = Rejection.only_deleted.find_by_delivery_id(delivery.id)
        rejection.destroy
      end
      if final_payment = FinalPayment.only_deleted.find_by_id(delivery.final_payment_id)
        final_payment.destroy
      end
    end
    deliveries.destroy_all
  end
end
