class Recruiter < User
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_one :company, :foreign_key => :user_id
  before_create :init_blank_comapny

  private
  def init_blank_comapny
    create_company
  end
end
