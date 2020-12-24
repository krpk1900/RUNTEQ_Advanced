require 'rails_helper'

RSpec.describe 'AdminSites', type: :system do
  let(:admin) { create(:user, :admin) }

  before do
    login(admin)
    visit edit_admin_site_path
  end

  describe 'ブログのトップ画像を変更' do
    context 'トップ画像を1枚選択してアップロード' do
      it 'トップ画像が1枚登録されること' do
        attach_file 'Main image', "spec/fixtures/images/test.jpg"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.jpg']")
      end
    end
    context 'トップ画像を複数枚選択してアップロード' do
      it 'トップ画像が複数枚登録されること' do
        attach_file 'Main image', %w(spec/fixtures/images/test.jpg spec/fixtures/images/test2.jpg)
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.jpg']")
        expect(page).to have_selector("img[src$='test2.jpg']")
      end
    end
    context 'アップロード済みのトップ画像を削除' do
      it 'トップ画像が削除されること' do
        attach_file 'Main image', "spec/fixtures/images/test.jpg"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.jpg']")
        click_link '削除'
        expect(current_path).to eq edit_admin_site_path
        expect(page).not_to have_selector("img[src$='test.jpg']")
      end
    end
  end

  describe 'favicon画像を変更' do
    context 'favicon画像を1枚選択してアップロード' do
      it 'favicon画像が1枚登録されること' do
        attach_file 'favicon', "spec/fixtures/images/test.png"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.png']")
      end
    end
    context 'アップロード済みのfavicon画像を削除' do
      it 'favicon画像が削除されること' do
        attach_file 'favicon', "spec/fixtures/images/test.png"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.png']")
        click_link '削除'
        expect(current_path).to eq edit_admin_site_path
        expect(page).not_to have_selector("img[src$='test.png']")
      end
    end
  end

  describe 'og-image画像を変更' do
    context 'og-image画像を1枚選択してアップロード' do
      it 'og-image画像が1枚登録されること' do
        attach_file 'og:image', "spec/fixtures/images/test.jpg"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.jpg']")
      end
    end
    context 'アップロード済みのog-image画像を削除' do
      it 'og-image画像が削除されること' do
        attach_file 'og:image', "spec/fixtures/images/test.jpg"
        click_button '保存'
        expect(current_path).to eq edit_admin_site_path
        expect(page).to have_selector("img[src$='test.jpg']")
        click_link '削除'
        expect(current_path).to eq edit_admin_site_path
        expect(page).not_to have_selector("img[src$='test.jpg']")
      end
    end
  end
end
