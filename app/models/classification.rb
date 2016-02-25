class Classification < ActiveRecord::Base
  has_many :children, class_name: :Classification, dependent: :destroy, foreign_key: :parent_id
  belongs_to :parent, class_name: :Classification

  validates_presence_of :name, maximum: 50
  validates_uniqueness_of :name

  scope :roots, -> { where("parent_id is null")}
end