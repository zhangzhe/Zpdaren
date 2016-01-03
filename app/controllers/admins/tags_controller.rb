class Admins::TagsController < Admins::BaseController

  def index
    tags = Job.tag_counts_on(:tags).order('taggings_count DESC')
    @nomal_tags = tags.where(priority: [nil, 0])
    @priority_tags = tags.where(:priority => 1)
  end
end
