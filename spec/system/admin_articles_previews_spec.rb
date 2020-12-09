require 'rails_helper'

RSpec.describe "AdminArticlesPreviews", type: :system do
  let(:admin) { create(:user, :admin) }

  describe '記事作成画面で画像ブロックを追加' do
    context '画像を添付せずにプレビューを閲覧' do
      it '正常に表示される' do
        login(admin)
        click_link '記事'
        click_link '新規作成'
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'スラッグ', with: 'test'
        fill_in '概要',	with: '記事概要'
        click_button '登録する'
        click_link 'ブロックを追加する'
        click_link '画像'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_content 'テスト記事'
      end
    end
  end
end
