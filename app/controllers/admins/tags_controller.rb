class Admins::TagsController < Admins::BaseController

  def index
  end

  def update
    respond_to do |format|
      tag_name = params[:tag].strip
      tag = Tag.find_by_name(tag_name)
      if tag.update_attributes!(:priority => params[:priority].to_i)
        flash[:success] = "更新成功"
        format.js {}
      else
        format.json { render json: tag, status: 500 }
      end
    end
  end
end
