class CommentsController < ActionController::Base

  def create
    respond_to do |format|
      update_user_info_if_login_user
      if params[:comment][:parent_id].to_i > 0
        @parent = Comment.find_by_id(params[:comment].delete(:parent_id))
        @comment = @parent.children.build(comment_params)
      else
        @comment = Comment.new(comment_params)
      end
      @interview = Interview.find(params[:interview_id])
      @comment.interview_id = params[:interview_id]
      if @comment.save
        format.html { redirect_to @interview, notice: '回复失败' }
        format.js   {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @interview, error: '回复失败，请填写好回复内容' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    comment = Comment.find(params[:id])
    comment.like_count += 1
    if comment.save
      session[comment.id] = comment.id
      render json: { status: 'OK', like_count: comment.like_count }
    else
      render json: { status: 'ERROR' }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter_name, :content, :interview_id, :commenter_id)
  end

  def update_user_info_if_login_user
    if (current_user && params[:comment][:commenter_name] && (current_user != params[:comment][:commenter_name]))
      current_user.name = params[:comment][:commenter_name]
      current_user.save!
    end
  end
end
