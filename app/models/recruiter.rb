class Recruiter < User
  devise :database_authenticatable, :registerable, :trackable, :validatable, :recoverable

  has_one :company, :foreign_key => :user_id
  has_many :petitions
  before_create :init_blank_comapny

  private
  def init_blank_comapny
    create_company
  end
end
