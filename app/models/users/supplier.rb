class Supplier < User
  devise :registerable
  has_many :resumes
  has_many :deliveries, through: :resumes
  has_many :watchings
  delegate :money, to: :wallet, prefix: true
  before_destroy :destroy_all_association_entities

  scope :max_priority, -> { where("users.id in (?)", Resume.max_priority.map(&:supplier_id)) }

  include DataRecoverer
  extend Statistics

  private
  def destroy_all_association_entities
    self.supplier_recover
  end
end
