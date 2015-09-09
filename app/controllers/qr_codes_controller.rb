class QrCodesController < ApplicationController
  def show
    scene_id = params[:id]
    response = Weixin.conn.get '/cgi-bin/token', { :appid => Weixin.mp_appid, :secret => Weixin.mp_secret, :grant_type => "client_credential" }
    response_result = JSON(response.body)

    response = Weixin.conn.post do |req|
      req.url "/cgi-bin/qrcode/create?access_token=#{response_result['access_token']}"
      req.body = "{ \"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": { \"scene\": { \"scene_id\": #{scene_id} } } }"
    end
     response_result = JSON(response.body)
     redirect_to "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{response_result['ticket']}"
  end
end
