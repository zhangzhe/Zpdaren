module Suppliers::DeliveriesHelper
  def self.state_show(delivery)
    case delivery.state.to_sym
    when :recommended
      '已推荐'
    when :viewed
      '被查看'
    when :paid
      '已付费'
    end
  end
end
