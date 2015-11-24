class Weixin < ActiveRecord::Base
  belongs_to :user

  scope :max_priority, -> { where("user_id in (?)", Supplier.max_priority.map(&:id)) }

  extend WeixinConnection
end
