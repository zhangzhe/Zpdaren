class EmailSendJob < ActiveJob::Base
  queue_as Settings.sidekiq.email_queue

  def perform(*args)
    RecruiterMailer.job_approved(args).deliver_now
  end
end