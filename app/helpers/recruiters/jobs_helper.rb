module Recruiters::JobsHelper
  def self.state_show(job)
    case job.state.to_sym
    when :submitted
      '未付订金'
    when :freezing
      '已下架'
    when :deposit_paid
      '待审核'
    when :approved
      '招聘进行中'
    when :finished
      '招聘完成'
    end
  end
end
