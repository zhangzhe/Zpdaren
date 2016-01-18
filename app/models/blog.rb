class Blog < ActiveRecord::Base

  def to_param
    "#{id}-blog-with-#{slug}"
  end

  private
  def slug
    Pinyin.t(title.downcase).split(' ').join('-')
  end
end
