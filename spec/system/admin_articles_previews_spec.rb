require 'rails_helper'

RSpec.describe "AdminArticlesPreviews", type: :system do
  let(:admin){ create(:user, :admin) }
  before{ login_as(admin) }

  let(:article){ create(:article) }

  describe '記事作成画面で画像ブロックを追加' do
    describe 'プレビュー' do
      context "画像を添付しないでプレビュー " do
        it '正常にプレビューページが表示される' , focus:true do
          click_link '記事'
          click_link '新規作成'
          fill_in 'タイトル', with: '記事タイトル'
          fill_in 'スラッグ', with: 'test'
          fill_in '概要',	with: '記事概要'
          click_button '登録する'
          click_link 'ブロックを追加する'
          click_on '画像'
          click_link 'プレビュー'
          switch_to_window(windows.last)
          expect(page).to have_content '記事タイトル'
        end
      end
    end
  end
end
