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

  def badge_for_recruiter_jobs(recruiter)
    " <span class=\"badge\">#{recruiter.in_hiring_jobs_count}/#{recruiter.jobs_count}</span>" if (recruiter.jobs_count > 0)
  end
end
