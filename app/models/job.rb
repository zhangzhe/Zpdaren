class Job < ActiveRecord::Base
  belongs_to :company

  def company_name
    company.name
  end

  def company_description
    company.description
  end
end
