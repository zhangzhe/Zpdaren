class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
  end

  def create
    begin
      resume = Resume.create!(resume_params)
      redirect_to resumes_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = '不支持该格式的文件上传'
      redirect_to :back
    end

  end

  def destroy

  end

  def download
    if Resume.find(params[:id])
      send_file Resume.find(params[:id]).attachment.file.file
    end
  end

  private
  def resume_params
      params.require(:resume).permit!()
  end
end