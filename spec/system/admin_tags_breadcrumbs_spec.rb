require 'rails_helper'

RSpec.describe "AdminTagsBreadcrumbs", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:tag){ create(:tag) }

  describe 'タグ一覧画面にパンくずを表示' do
    it '正常に表示される' do
      login(admin)
      click_link 'タグ'
      expect(page).to have_link 'Home'
      expect(page).to have_selector '.current', text: 'タグ'
    end
  end

  describe 'タグ編集画面にパンくずを表示' do
    it '正常に表示される' do
      login(admin)
      click_link 'タグ'
      click_link '編集'
      expect(page).to have_link 'Home'
      expect(page).to have_selector '.current', text: 'タグ編集'
    end
  end
end
