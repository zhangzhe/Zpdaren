class Tag < ActiveRecord::Base

  default_scope { order('taggings_count DESC') }

  class << self
    def find_by_q(params)
      where("name ilike ?", "%#{params[:q]}%").limit(params[:limit])
    end
  end
end
