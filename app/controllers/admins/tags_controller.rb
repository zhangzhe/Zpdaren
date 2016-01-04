class Admins::TagsController < Admins::BaseController

  def index
    tags = Job.tag_counts_on(:tags).order('taggings_count DESC')
    @nomal_tags = tags.where(priority: [nil, 0])
    @priority_tags = tags.where(:priority => 1)
  end

  def update
    respond_to do |format|
      tag_name = params[:tag].strip
      tag = Tag.find_by_name(tag_name)
      if tag.update_attributes!(:priority => params[:priority].to_i)
        tags = Job.tag_counts_on(:tags).order('taggings_count DESC')
        @nomal_tags = tags.where(priority: [nil, 0])
        @priority_tags = tags.where(:priority => 1)
        format.js {}
      else
        format.json { render json: tag, status: 500 }
      end
    end
  end
end
