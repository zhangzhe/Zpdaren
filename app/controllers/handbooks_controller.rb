class HandbooksController < ApplicationController

  def good_job_description
    send_file "public/pdfs/good_job_description.pdf"
  end

  def markdown

  end

  def company_service_protocol
    send_file "public/pdfs/company_service_protocol.pdf"
  end
end
