require 'markdown'

module MarkdownHelper

  ALLOW_TAGS = %w(p br img h1 h2 h3 h4 h5 h6 blockquote pre code b i
                  strong em table tr td tbody th strike del u a ul ol li span hr)
  ALLOW_ATTRIBUTES = %w(href src class id title alt target rel data-floor)

  def sanitize_markdown(body)
    sanitize body, tags: ALLOW_TAGS, attributes: ALLOW_ATTRIBUTES
  end

  def markdown(text)
    sanitize_markdown(MarkdownJobConverter.format(text))
  end
end
