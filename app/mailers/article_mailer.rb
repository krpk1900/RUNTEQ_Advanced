class ArticleMailer < ApplicationMailer
  def report_summary
    @published_articles_num = Article.published.count

    # binding.pry
    @published_articles_yesterday = Article.yesterday
    @published_articles_num_yesterday = @published_articles_yesterday.count
    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
end