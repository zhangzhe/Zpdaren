class Blog < ActiveRecord::Base

  def slug
    Pinyin.t(title.downcase).split(' ').join('-')
  end

  def to_param
    "#{id}-blog-with-#{slug}"
  end
end
