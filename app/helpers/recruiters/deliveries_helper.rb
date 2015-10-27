module Recruiters::DeliveriesHelper
  def self.state_show(delivery)
    case delivery.state.to_sym
    when :recommended
      '未查看'
    when :approved
      delivery.ever_paid_or_final_payment_paid_or_finished? && !delivery.unread? ? '已查看' : ''
    when :paid
      '已付费'
    when :refused
      '已拒绝'
    when :final_payment_paid
      '已支付尾款'
    when :finished
      '完成招聘'
    end
  end
end
