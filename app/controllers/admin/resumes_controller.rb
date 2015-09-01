class Admin::ResumesController < ApplicationController
  def index
    @resumes = Resume.where({checked: false})
  end
end