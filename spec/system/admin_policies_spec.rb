require 'rails_helper'

RSpec.describe "AdminPolicies", type: :system do
  let(:writer) { create(:user, :writer) }
  let(:editor) { create(:user, :editor) }
  let(:admin) { create(:user, :admin) }
  let!(:tag) { create(:tag) }
  let!(:author) { create(:author) }
  let!(:category) { create(:category) }

  before do
    # avoid Capybara::NotSupportedByDriverError to use page.status_code
    driven_by(:rack_test)
  end

  describe 'ライターのアクセス権限' do
    before do
      login(writer)
    end

    context 'ダッシュボードにアクセス' do
      it 'カテゴリーページへのリンクが表示されていないこと' do
        visit admin_articles_path
        expect(page).not_to have_link 'カテゴリー'
      end
      it 'タグページへのリンクが表示されていないこと' do
        visit admin_articles_path
        expect(page).not_to have_link 'タグ'
      end
      it '著者ページへのリンクが表示されていないこと' do
        visit admin_articles_path
        expect(page).not_to have_link '著者'
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content category.name
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセス失敗となり、403エラーが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{author.name}]")
      end
    end
  end

  describe '編集者のアクセス権限' do
    before do
      login(editor)
    end

    context 'ダッシュボードにアクセス' do
      it 'カテゴリーページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link 'カテゴリー'
      end
      it 'タグページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link 'タグ'
      end
      it '著者ページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link '著者'
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセス成功となり、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(200)
        expect(page).to have_content category.name
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセス成功となり、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセス成功となり、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセス成功となり、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセス成功となり、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセス成功となり、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{author.name}]")
      end
    end
  end

  describe '管理者のアクセス権限' do
    before do
      login(admin)
    end

    context 'ダッシュボードにアクセス' do
      it 'カテゴリーページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link 'カテゴリー'
      end
      it 'タグページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link 'タグ'
      end
      it '著者ページへのリンクが表示されること' do
        visit admin_articles_path
        expect(page).to have_link '著者'
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセス成功となり、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(200)
        expect(page).to have_content category.name
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセス成功となり、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセス成功となり、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセス成功となり、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセス成功となり、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセス成功となり、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{author.name}]")
      end
    end
  end
end
