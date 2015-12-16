class Suppliers::WithdrawsController < Suppliers::BaseController
  before_filter :choose_layout

  include WithdrawCore
end
