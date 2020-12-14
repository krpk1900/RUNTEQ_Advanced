require 'rails_helper'

RSpec.describe "AdminArticles", type: :system do
  let(:admin) { create(:user, :admin) }
  let(:future_article) { create(:article, :future) }
  let(:past_article){ create(:article, :past) }
  let(:draft_article){ create(:article, :draft) }
  before do
      login(admin)
    end
  describe '記事編集画面' do
    context '公開日時を未来の日付に設定し「公開」を押す' do
      it 'ステータスを「公開待ち」に変更して「記事を公開待ちにしました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(future_article.uuid)
        click_link '公開する'
        expect(page).to have_content '記事を公開待ちにしました'
        expect(page).to have_select('状態', selected: '公開待ち')
      end
    end
    context '公開日時を過去の日付に設定し「公開する」を押す' do
      it 'ステータスを「公開」に変更して「記事を公開しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        click_link '公開する'
        expect(page).to have_content '記事を公開しました'
        expect(page).to have_select('状態', selected: '公開')
      end
    end
    context 'ステータスが下書き以外の状態で公開日時を未来の日付に設定し「更新する」を押す' do
      it 'ステータスを「公開待ち」に変更して「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(future_article.uuid)
        click_button '更新する'
        expect(page).to have_content '更新しました'
        expect(page).to have_select('状態', selected: '公開待ち')
      end
    end
    context 'ステータスが下書き以外の状態で公開日時を過去の日付に設定し「更新する」を押す' do
      it 'ステータスを「公開」に変更して「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        click_button '更新する'
        expect(page).to have_content '更新しました'
        expect(page).to have_select('状態', selected: '公開')
      end
    end
    context 'ステータスが下書き状態で「更新する」を押す' do
      it 'ステータスは「下書き」のまま「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(draft_article.uuid)
        click_button '更新する'
        expect(page).to have_content '更新しました'
        expect(page).to have_selector '.form-control', text: '下書き'
      end
    end
  end
end
