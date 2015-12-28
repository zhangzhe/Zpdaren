class Admins::InterviewsController < Admins::BaseController
  def index
    @interviews = Interview.all
  end

  def new
    @interview = Interview.new
  end

  def create
    @interview = Interview.new(interview_params)
    @professor = Professor.new(professor_params)
    @interview.professor = @professor
    if (@professor.save && @interview.save)
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
    @interview.update(interview_params)
    @professor.update(professor_params)
    if @interview.errors.any? || @professor.errors.any?
      flash[:error] = @interview.errors.full_messages.first || @professor.errors.full_messages.first
      render 'edit' and return
    end
    redirect_to @interview
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
  def interview_params
    params.require(:interview).permit(:professor_title, :content, :avatar, :professor_name, :brief)
  end

  def professor_params
    { :email => params[:professor_email], :password => params[:professor_password], :name => params[:interview][:professor_name] }
  end
end
