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
    def active_suppliers_recently_seven_days
      Supplier.joins(:resumes, :deliveries).where("deliveries.created_at >= ? and deliveries.created_at <= ?", Time.now.at_beginning_of_day - 7.days, Time.now).distinct
    end

    def active_supplier_count_recently_seven_days
      active_suppliers_recently_seven_days.count
    end

    def newly_active_supplier_recently_seven_days
      active_suppliers_recently_seven_days.where("users.created_at >= ? and users.created_at <= ?", Time.now.at_beginning_of_day - 7.days, Time.now)
    end

    def newly_active_supplier_count_recently_seven_days
      newly_active_supplier_recently_seven_days.count
    end
  end

  private
  def destroy_all_association_entities
    self.supplier_recover
  end
end
