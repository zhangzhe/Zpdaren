class Api::TagsController < ApplicationController

  def index
    tags = Tag.find_by_q(params)
    render json: tags.map {|tag| tag.name }.join("\n").to_json
  end
end
