module Recruiters::JobsHelper
  def self.state_show(job)
    case job.state.to_sym
    when :offline
      '未支付'
    when :online
      '已发布'
    when :finish
      '已完成'
    else
      '未支付'
    end
  end
end