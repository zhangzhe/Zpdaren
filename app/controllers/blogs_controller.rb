class BlogsController < ActionController::Base
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  layout 'anonymous_job'

  def index
    @blogs = Blog.all
  end

  def show
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end
end
