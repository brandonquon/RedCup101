module ArticlesHelper

  def url_changing(article)
    article.parse(url).host[/(?:www\.)?(.*)/,1]
  end
end
