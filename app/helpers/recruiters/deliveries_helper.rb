module Recruiters::DeliveriesHelper
  def self.state_show(delivery)
    case delivery.state.to_sym
    when :recommended
      '未查看'
    when :paid
      '已查看'
    when :refused
      '已拒绝'
    end
  end
end
