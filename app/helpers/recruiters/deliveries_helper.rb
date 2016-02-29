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

  def badge_for_recruiter_deliveries(recruiter)
    " <span class=\"badge\">#{recruiter.find_deliveries_count_by_state('unprocess')}/#{recruiter.recruiter_watchable_deliveries_count}</span>" if (recruiter.recruiter_watchable_deliveries_count > 0)
  end

  def outdated?
    (params[:state] == 'available') and (current_recruiter.find_deliveries_count_by_state('outdated', params[:job_id]) > 0)
  end
end
