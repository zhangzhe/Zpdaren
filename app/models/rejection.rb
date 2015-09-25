class Rejection < ActiveRecord::Base
  belongs_to :delivery
  serialize :reason
  validates_presence_of :reason, message: '请填写拒绝原因！', if: :other_is_empty?
  after_create :notify_supplier

  private
  def notify_supplier
    Weixin.send_resume_refused_notification(self.delivery)
  end

  def other_is_empty?
    self.other.empty?
  end
end
