module Admins::DeliveriesHelper
  def deliveries_count(deliveries, state)
    deliveries.send(state).count
  end
end
