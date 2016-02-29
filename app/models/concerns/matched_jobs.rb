module MatchedJobs
  def matched_jobs
    result = []
    self.tag_list.each do |tag|
      jobs = Job.joins(:classification).where("LOWER(classifications.name) = ?", tag.downcase)
      result << jobs if jobs.present?
    end
    result = result.flatten.uniq.map {|job| job if !self.deliveried?(job)  }
    result.compact
  end
end