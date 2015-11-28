class Rejection < ActiveRecord::Base
  belongs_to :delivery
  serialize :reason
  validates_presence_of :reason, if: :other_is_empty?

  strip_attributes
  acts_as_paranoid

  private

  def other_is_empty?
     self.other.nil?
  end
end
