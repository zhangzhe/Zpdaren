module Recruiters::JobsHelper
  def self.state_show(job)
    case job.state.to_sym
    when :submitted
      '未付订金'
    when :approved
      '已付订金'
    when :finished
      '已完成'
    end
  end
end
