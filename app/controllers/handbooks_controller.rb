class HandbooksController < ApplicationController

  def good_job_description
    send_file "public/pdfs/good_job_description.pdf"
  end

  def markdown

  end
end
