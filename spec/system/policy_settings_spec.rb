require 'rails_helper'

RSpec.describe "PolicySettings", type: :system do
  let(:writer) { create(:user, :writer) }
  let(:tag) { create(:tag) }
  let(:author) { create(:author) }
  let(:category) { create(:category) }

  before do
    login(writer)
  end

  describe 'ライターの権限' do
    it 'タグの一覧表示をしようとすると、403エラーページが表示される' do
      visit admin_tags_path
      expect(page).to have_content '403'
    end
    it 'タグの編集をしようとすると、403エラーページが表示される' do
      visit edit_admin_tag_path(tag)
      expect(page).to have_content '403'
    end
    xit 'タグの削除をしようとすると、403エラーページが表示される' do
      visit admin_tag_path(tag)
      expect(page).to have_content '403'
    end

    it '著者の一覧表示をしようとすると、403エラーページが表示される' do
      visit admin_authors_path
      expect(page).to have_content '403'
    end
    it '著者の編集をしようとすると、403エラーページが表示される' do
      visit edit_admin_author_path(author)
      expect(page).to have_content '403'
    end
    xit '著者の削除をしようとすると、403エラーページが表示される' do
      visit admin_author_path(author)
      expect(page).to have_content '403'
    end

    it 'カテゴリーの一覧表示をしようとすると、403エラーページが表示される' do
      visit admin_categories_path
      expect(page).to have_content '403'
    end
    it 'カテゴリーの編集をしようとすると、403エラーページが表示される' do
      visit edit_admin_category_path(category)
      expect(page).to have_content '403'
    end
    xit 'カテゴリーの削除をしようとすると、403エラーページが表示される' do
      visit admin_category_path(category)
      expect(page).to have_content '403'
    end
  end
end
