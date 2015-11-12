class AddPdfAttachmentToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :pdf_attachment, :text
  end
end
