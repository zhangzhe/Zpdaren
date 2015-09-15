class RefuseReason < ActiveRecord::Base
  belongs_to :delivery

  after_create :notify_supplier

  private
  def notify_supplier
    # Weixin.notify_resume_refused(self.delivery)
  end
end