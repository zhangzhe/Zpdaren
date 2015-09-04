class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume

  scope :paid, -> { where(paid: true) }

  def candidate_name
    resume.candidate_name
  end

  def description
    resume.description
  end

  def pay!
    self.update_attributes!(paid: true)
  end

end
