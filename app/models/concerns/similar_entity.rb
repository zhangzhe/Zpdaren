module SimilarEntity
  def similar_entity(entity)
    result = []
    tag_group.each do |tags|
      entities = entity.tagged_with(tags)
      result << entities unless entities.blank?
    end
    result.flatten.uniq - [self]
  end

  def tag_group
    self.tags.map(&:name).combination(group_size).to_a
  end

  def group_size
    (self.tags.count*0.6).round
  end
end
