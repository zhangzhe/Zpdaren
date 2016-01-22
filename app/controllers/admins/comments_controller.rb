class Admins::CommentsController < Admins::BaseController
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js   {}
    end
  end
end
