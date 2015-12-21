module Admins::JobsHelper
  def options_for_post_priority(job)
    options_for_select([['高优先级', 1], ['中优先级', 2], ['低优先级', 3]], job.priority || 3)
  end
end