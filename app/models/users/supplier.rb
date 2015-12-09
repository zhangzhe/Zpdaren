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

  class << self
    def active_suppliers_this_week
      resume_ids = Delivery.where("created_at >= ? and created_at <= ?", Time.now.beginning_of_week, Time.now.beginning_of_week + 7.days).map(&:resume_id)
      Supplier.joins(:resumes).where("resumes.id in (?)", resume_ids)
    end

    def active_supplier_count_this_week
      active_suppliers_this_week.count
    end
  end

  private
  def destroy_all_association_entities
    self.supplier_recover
  end
end
