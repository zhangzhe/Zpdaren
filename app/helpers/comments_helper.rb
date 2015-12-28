module CommentsHelper
  def comments_tree_for(comments)
    comments.map do |comment, nested_comments|
      render(partial: "comment", locals: {comment: comment}) +
          (nested_comments.size > 0 ? content_tag(:div, comments_tree_for(nested_comments), class: "replies") : nil)
    end.join.html_safe
  end
end
