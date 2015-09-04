class Recruiters::ResumesController < Admins::BaseController
  layout "recruiters"

  def index
    @resumes = Resume.joins(:deliveries).select(:candidate_name, 'deliveries.job_id').where("deliveries.job_id in (?)", current_recruiter.company.jobs.collect {|job| job.id }).active
  end

  def show
    @resume = Resume.find(params[:id])
    delivery = @resume.deliveries.where("job_id=?", params[:job_id])
  end

  def pay
    resume = Resume.find(params[:id])
    delivery = resume.deliveries.where("job_id=?", params[:job_id])
    unless delivery.paid
      job = resume.jobs.find(params[:job_id])
      job.view_pay(params[:pay])
      resume.supplier.receive(params[:pay])
    end
    redirect_to recruiters_resume_path(resume)
  end
end
