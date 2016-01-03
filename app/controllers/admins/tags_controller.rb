class Admins::TagsController < Admins::BaseController

  def index
    @tags = Job.tag_counts_on(:tags).order('taggings_count DESC')

  end
end
