class CommentsController < ActionController::Base

  def create
    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      comment = parent.children.build(comment_params)
    else
      comment = Comment.new(comment_params)
    end
    @interview = Interview.find(params[:interview_id])
    comment.interview_id = params[:interview_id]
    if comment.save
      redirect_to @interview, notice: '回复失败'
    else
      flash[:error] = comment.errors.full_messages.first
      redirect_to @interview, error: '回复失败，请填写好回复内容'
    end
  end

  def comment_params
    params.require(:comment).permit(:commenter_name, :content, :interview_id)
  end
end
