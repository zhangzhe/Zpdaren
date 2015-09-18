class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id

  before_update :validate_name_and_decription

  scope :active, -> { where.not('name' => nil) }
  default_scope { order('created_at DESC') }

  private

  def validate_name_and_decription
    validates_presence_of :name, message: '请填写公司名称！'
    validates_presence_of :description, message: '请填写公司描述！'
    validates_length_of :name, maximum: 20, too_long: '公司名称不能超过20个字！'
  end
end
