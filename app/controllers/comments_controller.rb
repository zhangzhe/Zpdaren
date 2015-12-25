class CommentsController < ActionController::Base
  def create
    @interview = Interview.find(params[:interview_id])
    if @interview.comments.create(comment_params)
      redirect_to @interview, notice: '创建成功'
    else
      flash[:error] = @interview.errors.full_messages.first
      render :back
    end
  end

  def comment_params
    params.require(:comment).permit(:commenter_name, :content)
  end
end
