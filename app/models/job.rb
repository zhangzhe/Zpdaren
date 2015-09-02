class Job < ActiveRecord::Base
  belongs_to :company
  has_many :deliveries
  has_many :resumes, through: :deliveries

  def company_name
    company.name
  end

  def company_description
    company.description
  end

  def delivery!(resume)
    Delivery.create(:resume_id => resume.id, :job_id => self.id)
  end
end
