class Rejection < ActiveRecord::Base
  belongs_to :delivery
  serialize :reason
  validates_presence_of :reason, message: '请填写拒绝原因！', if: :other_is_empty?

  after_create :notify_supplier

  private
  def notify_supplier
    Weixin.notify_resume_refused(self.delivery) if Rails.env == 'production'
  end

  def reason_is_nil?
    self.reason.nil?
  end

  def other_is_empty?
    self.other.empty?
  end
end
