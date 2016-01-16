module InterviewsHelper
  def show_path(interview)
    interview_path(:id => "#{interview.id}-ama-with-#{interview.professor_name}")
  end
end