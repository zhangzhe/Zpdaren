class InterviewsConstraint
  def matches?(request)
    id = request.env['action_dispatch.request.path_parameters'][:id].strip
    return false if id.blank?
    return false unless interview = Interview.find_by_id(id.split[0])
    "#{interview.id}-ama-with-#{interview.professor_name}" == id
  end
end
