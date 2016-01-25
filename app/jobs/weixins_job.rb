class WeixinsJob < ActiveJob::Base
  queue_as :weixins

  def perform(args)
    Weixin.send(args[:event], args[:id])
  end
end
