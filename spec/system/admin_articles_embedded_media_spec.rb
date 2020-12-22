require 'rails_helper'

RSpec.describe "AdminArticlesEmbeddedMedia", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:article) { create(:article) }

  describe '記事の埋め込みブロックを追加' do
    before do
      login(admin)
      visit edit_admin_article_path(article.uuid)
      click_link 'ブロックを追加する'
      click_link '埋め込み'
      click_link '編集'
    end

    context 'YouTubeを選択しアップロード' do
      it 'プレビューした記事にYouTubeが埋め込まれていること', js: true do
        select 'YouTube', from: '埋め込みタイプ'
        fill_in 'ID',	with: 'https://youtu.be/dZ2dcC4OnQE'
        page.all('.box-footer')[0].click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/dZ2dcC4OnQE']")
      end
    end

    context 'Twitterを選択しアップロード' do
      it 'プレビューした記事にYouTubeが埋め込まれていること', js: true do
        select 'Twitter', from: '埋め込みタイプ'
        fill_in 'ID',	with: 'https://twitter.com/_RUNTEQ_/status/1219795644807667712'
        page.all('.box-footer')[0].click_button '更新する'
        sleep 1
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        expect(page).to have_selector('.twitter-tweet')
      end
    end
  end
end
