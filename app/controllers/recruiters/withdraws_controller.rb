class Recruiters::WithdrawsController < Recruiters::BaseController
  before_filter :choose_layout

  include WithdrawCore
end
