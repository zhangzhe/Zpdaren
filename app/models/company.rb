class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id

  validates_presence_of :name, on: :update, message: '请填写公司名称！'
  validates_presence_of :description, on: :update, message: '请填写公司描述！'
  validates_length_of :name, on: :update, maximum: 50, too_long: '公司名称不能超过50个字！'
  validates_presence_of :mobile, on: :update, message: '请填写公司联系方式！'

  scope :active, -> { where.not('name' => nil) }
  default_scope { order('created_at DESC') }

  strip_attributes
end
