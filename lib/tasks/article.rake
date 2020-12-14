namespace :article do
  desc '時間によって記事を公開するタスク'
  task publish: :environment do
    Article.publish_wait.each do |article|
      if article.published_at <= Time.current
        article.published!
      end
    end
  end
end
