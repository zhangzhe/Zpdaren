module Suppliers::DeliveriesHelper
  def self.state_show(delivery)
    case delivery.state.to_sym
    when :recommended
      '已推荐，未审核'
    when :approved
      if delivery.ever_paid?
        '已付费'
      else
        '审核通过'
      end
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
