class Admins::InterviewsController < Admins::BaseController
  def index
    @interviews = Interview.all
  end

  def new
    @interview = Interview.new
  end

  def create
    @interview = Interview.new(raw_interview_params)
    @professor = Professor.new(raw_professor_params)
    @interview.professor = @professor
    saved = false
    begin
      ActiveRecord::Base.transaction do
        saved = @professor.save! && @interview.save!
      end
    rescue ActiveRecord::RecordInvalid
    end
    if saved
      redirect_to @interview, notice: '创建成功'
    else
      flash[:error] = @interview.errors.full_messages.first || @professor.errors.full_messages.first
      render :new
    end
  end

  def edit
    @interview = Interview.find(params[:id])
    @professor = @interview.professor
  end

  def update
    @interview = Interview.find(params[:id])
    @professor = @interview.professor || @interview.build_professor
    interview_params = raw_interview_params.delete_if { |k, v| v.blank? }
    professor_params = raw_professor_params.delete_if { |k, v| v.blank? }
    if @interview.update(interview_params) && @professor.update(professor_params)
      redirect_to @interview, notice: '更新成功'
    else
      flash[:error] = @interview.errors.full_messages.first || @professor.errors.full_messages.first
      render 'edit'
    end
  end

  def destroy
    interview = Interview.find(params[:id])
    if interview.destroy
      flash[:success] = '删除成功。'
      redirect_to admins_interviews_path
    else
      flash[:error] = '程序异常，删除失败。'
      redirect_to admins_interviews_path
    end
  end

  private
  def raw_interview_params
    params.require(:interview).permit(:professor_title, :content, :avatar, :professor_name, :brief, :reply_begin_at, :reply_end_at)
  end

  def raw_professor_params
    { :email => params[:professor_email], :password => params[:professor_password], :name => params[:interview][:professor_name] }
  end
end
