class AmaController < ApplicationController
  before_action :detect_browser, :only => [:index]

  def index
    render layout: 'application'
  end

  def show
    render layout: 'ama'
  end

  def detect_browser
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end
end
