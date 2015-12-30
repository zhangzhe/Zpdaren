class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id

  validates_presence_of :name, :description, :mobile, :address, on: :update
  validates_length_of :name, on: :update, maximum: 50

  scope :active, -> { where.not('name' => nil) }
  default_scope { order('created_at DESC') }

  strip_attributes
  mount_uploader :service_protocol, ProtocolUploader

  def service_protocol_is_pdf?
    self.service_protocol.current_path.end_with?('pdf')
  end

  def info_completed?
    self.name.present? && self.description.present? && self.mobile.present? && self.address.present?
  end
end
