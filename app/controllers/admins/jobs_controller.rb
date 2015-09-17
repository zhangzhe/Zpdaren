class Admins::JobsController < Admins::BaseController
  before_action :set_page, only: [:index, :search]

  def index
    if params[:key].present?
      @jobs = Job.where("title ilike ?", "%#{params[:key]}%").paginate(page: params[:page], per_page: Settings.pagination.page_size)
    else
      @jobs = Job.paginate(page: params[:page], per_page: Settings.pagination.page_size)
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    job.update_and_approve(job_params)
    redirect_to admins_jobs_path
  end

  def complete
    job = Job.find(params[:id])
    final_payment_request = job.final_payment_request
    supplier = final_payment_request.supplier
    Job.transaction do
      supplier.wallet.update_money(:+, job.bonus_for_entry)
      job.complete!
      job.final_payment_request.pay!
    end
    redirect_to :back
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :tag_list)
  end

  def set_page
    params[:page] ||= 1
  end

  def total_page(jobs)
    if jobs.count % Settings.pagination.page_size == 0
      jobs.count / Settings.pagination.page_size
    else
      jobs.count / Settings.pagination.page_size + 1
    end
  end
end
