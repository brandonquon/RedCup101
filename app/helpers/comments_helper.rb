module CommentsHelper
  def url_fixed(comment)
    Comment.parse(comment).host[/(?:www\.)?(.*)/,1]
  end

end
