class Admins::ResumesController < Admins::BaseController
  helper_method :sort_column

  def index
    if params[:key].present?
      @resumes = Resume.tagged_with([params[:key]], any: true, wild: true)
    else
      @resumes = Resume.all
    end
    @resumes = @resumes.order("#{params[:sort]} #{params[:direction]}")
    @resumes = @resumes.paginate(page: params[:page], per_page: Settings.pagination.page_size)
  end

  def edit
    @resume = Resume.find(params[:id])
    @delivery = Delivery.find(params[:delivery_id])
  end

  def update
    @resume = Resume.update(params[:id], resume_params)
    if @resume.errors.any?
      flash[:error] = @resume.errors.full_messages.first
      render 'edit' and return
    end
    delivery = @resume.deliveries.find(params[:resume][:delivery_id])
    delivery.approve!
    redirect_to admins_deliveries_path
  end

  def download
    resume = Resume.find(params[:id])
    send_file resume.attachment.file.file
  end

  private
  def resume_params
    params.require(:resume).permit(:name, :mobile, :email, :description, :reviewed, :tag_list)
  end

  def sort_column
    Resume.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
