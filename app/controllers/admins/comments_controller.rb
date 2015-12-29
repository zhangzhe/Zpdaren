class Admins::CommentsController < Admins::BaseController
  def destroy
    respond_to do |format|
      @comment = Comment.find(params[:id])
      @comment.destroy
      format.html { redirect_to @comment.interview, notice: '删除成功' }
      format.js   {}
      format.json { render json: @comment, status: :deleted, location: @comment }
    end
  end
end
