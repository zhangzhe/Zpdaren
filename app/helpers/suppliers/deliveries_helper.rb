module Suppliers::DeliveriesHelper
  def self.state_show(delivery)
    case delivery.state.to_sym
    when :recommended
      '已推荐，未审核'
    when :approved
      '审核通过'
    when :paid
      '已付费'
    when :refused
      '已拒绝'
    end
  end
end
