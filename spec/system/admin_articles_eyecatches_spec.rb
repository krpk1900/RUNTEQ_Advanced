require 'rails_helper'

RSpec.describe "AdminArticlesEyecatches", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:article) { create(:article) }

  before do
    login(admin)
    visit admin_articles_path
    click_link '編集'
    attach_file 'article[eye_catch]', "#{Rails.root}/spec/fixtures/images/test.jpg"
    click_button '更新する'
  end

  describe 'アイキャッチの横幅を変更' do
    context '横幅を100pxから700pxに指定した場合' do
      it '記事の更新に成功し、プレビューでアイキャッチが確認できる' do
        eyecatch_width = rand(100..700)
        fill_in 'article[eyecatch_width]',	with: eyecatch_width
        click_button '更新する'
        expect(page).to have_content '更新しました'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.eye_catch')
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        expect(page).to have_selector("img[src$='test.jpg']")
      end
    end
    context '横幅を99px以下に指定した場合' do
      it '記事の更新に失敗する' do
        fill_in 'article[eyecatch_width]',	with: 99
        click_button '更新する'
        expect(page).not_to have_content '更新しました'
        expect(page).to have_content 'は100以上の値にしてください'
      end
    end
    context '横幅を701px以上に指定した場合' do
      it '記事の更新に失敗する' do
        fill_in 'article[eyecatch_width]',	with: 701
        click_button '更新する'
        expect(page).not_to have_content '更新しました'
        expect(page).to have_content 'は700以下の値にしてください'
      end
    end
  end
  describe 'アイキャッチの表示位置を変更' do
    context 'アイキャッチ画像を「右寄せ」に設定した場合' do
      it 'アイキャッチが「右寄せ」で表示される' do
        choose '右寄せ'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-right')
      end
    end
    context 'アイキャッチ画像を「中央」に設定した場合' do
      it 'アイキャッチが「中央」で表示される' do
        choose '中央'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-center')
      end
    end
    context 'アイキャッチ画像を「左寄せ」に設定した場合' do
      it 'アイキャッチが「左寄せ」で表示される' do
        choose '左寄せ'
        click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-left')
      end
    end
  end
end
