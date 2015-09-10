class Delivery < ActiveRecord::Base
  belongs_to :job
  belongs_to :resume

  delegate :candidate_name, :tag_list, :mobile, :email, to: :resume, prefix: true
  delegate :title, to: :job, prefix: true

  scope :paid, -> { where(state: 'paid') }

  after_create :notify_recruiter, if: Proc.new { self.resume.approved? }

  include AASM
  aasm.attribute_name :state
  aasm do
    state :recommended, :initial => true
    state :viewed
    state :paid

    event :view do
      transitions :from => :recommended, :to => :viewed
    end

    event :pay do
      transitions :from => :viewed, :to => :paid
    end
  end

  def candidate_name
    resume.candidate_name
  end

  def description
    resume.description
  end

  def notify_recruiter
    RecruiterMailer.email_resume_recommended(recruiter, resume, job).deliver_now
    p "notify_recruiter"
  end

  def recruiter
    job.company.recruiter
  end
end
