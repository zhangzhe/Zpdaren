class Company < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id

  validates_presence_of :name, on: :update
  validates_presence_of :description, on: :update
  validates_length_of :name, on: :update, maximum: 50
  validates_presence_of :mobile, on: :update
  validates_presence_of :service_protocol, on: :update, unless: Proc.new { |company| company.service_protocol? }

  scope :active, -> { where.not('name' => nil) }
  default_scope { order('created_at DESC') }

  strip_attributes
  mount_uploader :service_protocol, ProtocolUploader

  def service_protocol_is_pdf?
    self.service_protocol.current_path.end_with?('pdf')
  end
end
