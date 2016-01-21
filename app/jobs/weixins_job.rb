class WeixinsJob < ActiveJob::Base
  queue_as :weixins

  def perform(args)
    WeixinApi::Notification.send(args[:event], args[:id])
  end
end
