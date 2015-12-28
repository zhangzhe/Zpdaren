class Admin < User
  devise :database_authenticatable, :trackable

  BANK_ACCOUNT = '11054701040001271'

  DELIVERY_STATE_WHITE_LIST = ['recommended', 'approved', 'paid', 'final_paid', 'recruiter_refused', 'admin_refused']

  JOB_STATE_WHITE_LIST = ['high_priority', 'in_hiring', 'submitted', 'un_hiring', 'deleted']

  RESUMES_STATE_WHITE_LIST = ['uncompleted', 'completed', 'unavailable', 'available', 'problemed']

  def self.admin
    self.first
  end

  def find_deliveries_by_state(state)
    Delivery.send(state.downcase)
  end

  def find_deliveries_count_by_state(state)
    find_deliveries_by_state(state).count
  end

  def delivery_state_is_legal?(state)
    DELIVERY_STATE_WHITE_LIST.includes?((state || '').downcase)
  end

  def find_jobs_by_state(state)
    Job.send(state.downcase)
  end

  def find_jobs_count_by_state(state)
    find_jobs_by_state(state).count
  end

  def job_state_is_legal?(state)
    JOB_STATE_WHITE_LIST.include?((state || '').downcase)
  end

  def find_resumes_by_state(state)
    Resume.send(state.downcase)
  end

  def find_resumes_count_by_state(state)
    find_resumes_by_state(state).count
  end

  def resume_state_is_legal?(state)
    RESUMES_STATE_WHITE_LIST.include?((state || '').downcase)
  end
end
