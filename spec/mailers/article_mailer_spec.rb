require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  let(:article_publish_wait_tomorrow) { create(:article, :publish_wait_tomorrow) }
  let(:article_published_yesterday) { create(:article, :published_yesterday) }
  let(:article_published_two_days_ago) { create(:article, :published_two_days_ago) }
  let(:mail) { ArticleMailer.report_summary.deliver_now }
  let(:check_sent_mail) {
    expect(mail.present?).to be_truthy
    expect(mail.to).to eq(['admin@example.com'])
    expect(mail.subject).to eq('公開済記事の集計結果')
  }


  describe '公開済記事の集計結果通知メールの送信' do
    context '昨日までに公開された記事が存在しない場合' do
      it '昨日までに公開された記事がない旨の結果が送られること' do
        article_publish_wait_tomorrow
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 0件')
        expect(mail.body).to match('昨日公開された記事はありません')
        expect(mail.body).not_to match("タイトル: #{article_publish_wait_tomorrow.title}")
      end
    end
    context '公開日が昨日の記事が存在する場合' do
      it '公開日が昨日の記事を含めた集計結果が送られること' do
        article_publish_wait_tomorrow
        article_published_yesterday
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 1件')
        expect(mail.body).to match('昨日公開された記事数: 1件')
        expect(mail.body).not_to match("タイトル: #{article_publish_wait_tomorrow.title}")
        expect(mail.body).to match("タイトル: #{article_published_yesterday.title}")
      end
    end
    context '公開日が2日前の記事が存在する場合' do
      it '公開日が2日前の記事を含めた集計結果が送られること' do
        article_publish_wait_tomorrow
        article_published_two_days_ago
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 1件')
        expect(mail.body).to match('昨日公開された記事はありません')
        expect(mail.body).not_to match("タイトル: #{article_publish_wait_tomorrow.title}")
        expect(mail.body).not_to match("タイトル: #{article_published_two_days_ago.title}")
      end
    end
    context '公開日が昨日と2日前の記事が存在する場合' do
      it '公開日が昨日と2日前の記事を含めた集計結果が送られること' do
        article_publish_wait_tomorrow
        article_published_yesterday
        article_published_two_days_ago
        check_sent_mail
        expect(mail.body).to match('公開済の記事数: 2件')
        expect(mail.body).to match('昨日公開された記事数: 1件')
        expect(mail.body).not_to match("タイトル: #{article_publish_wait_tomorrow.title}")
        expect(mail.body).not_to match("タイトル: #{article_published_two_days_ago.title}")
        expect(mail.body).to match("タイトル: #{article_published_yesterday.title}")
      end
    end
  end
end
