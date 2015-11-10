module Recruiters::JobsHelper
  def self.state_show(job)
    case job.state.to_sym
    when :submitted
      '未付订金'
    when :deposit_paid
      '待确认'
    when :deposit_paid_confirmed
      '招聘中'
    when :final_payment_paid
      '支付确认中'
    when :finished
      '招聘完成'
    end
  end
end
