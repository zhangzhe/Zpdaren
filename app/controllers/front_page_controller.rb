class FrontPageController < ApplicationController
  protect_from_forgery :except => [:check_signature]

  def index
  end

  require 'digest/sha1'
  def check_signature
    logger.error(params.inspect)
    token = "12345qwert"
    signature = Digest::SHA1.hexdigest([token, params[:timestamp], params[:nonce]].sort.join)
    if signature == params[:signature]
      render :text => params[:echostr]
    else
      false
    end
  end
end
