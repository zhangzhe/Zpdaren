require 'markdown'

module JobsHelper
  def markdown(text)
    sanitize_markdown(MarkdownJobConverter.format(text))
  end
end
