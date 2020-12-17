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

  describe '検索機能' do
    let(:article_with_author) { create(:article, :with_author, author_name: '伊藤') }
    let(:article_with_another_author) { create(:article, :with_author, author_name: '鈴木') }
    let(:article_with_tag){ create(:article, :with_tag, tag_name: 'Ruby') }
    let(:article_with_another_tag){ create(:article, :with_tag, tag_name: 'PHP') }
    let(:past_article_with_sentence){ create(:article, :with_sentence, :past, sentence_body: '基礎編の記事') }
    let(:past_article_with_another_sentence){ create(:article, :with_sentence, :past, sentence_body: '応用編の記事') }
    let(:future_article_with_sentence){ create(:article, :with_sentence, :future, sentence_body: '基礎編の記事') }
    let(:future_article_with_another_sentence){ create(:article, :with_sentence, :future, sentence_body: '応用編の記事') }
    let(:draft_article_with_sentence){ create(:article, :with_sentence, :draft, sentence_body: '基礎編の記事') }
    let(:draft_article_with_another_sentence){ create(:article, :with_sentence, :draft, sentence_body: '応用編の記事') }

    it '著者で絞り込み検索ができること' do
      article_with_author
      article_with_another_author
      visit admin_articles_path
      select '伊藤', from: 'q[author_id]'
      click_button '検索'
      expect(page).to have_content article_with_author.title
      expect(page).not_to have_content article_with_another_author.title
    end
    it 'タグで絞り込み検索ができること' do
      article_with_tag
      article_with_another_tag
      visit admin_articles_path
      select 'Ruby', from: 'q[tag_id]'
      click_button '検索'
      expect(page).to have_content article_with_tag.title
      expect(page).not_to have_content article_with_another_tag.title
    end
    it '公開状態の記事について、本文で絞り込み検索ができること' do
      past_article_with_sentence
      past_article_with_another_sentence
      visit admin_articles_path
      fill_in 'q[body]',	with: '基礎編'
      click_button '検索'
      expect(page).to have_content past_article_with_sentence.title
      expect(page).not_to have_content past_article_with_another_sentence.title
    end
    it '公開待ち状態の記事について、本文で絞り込み検索ができること' do
      future_article_with_sentence
      future_article_with_another_sentence
      visit admin_articles_path
      fill_in 'q[body]',	with: '基礎編'
      click_button '検索'
      expect(page).to have_content future_article_with_sentence.title
      expect(page).not_to have_content future_article_with_another_sentence.title
    end
    it '下書き状態の記事について、本文で絞り込み検索ができること' do
      draft_article_with_sentence
      draft_article_with_another_sentence
      visit admin_articles_path
      fill_in 'q[body]',	with: '基礎編'
      click_button '検索'
      expect(page).to have_content draft_article_with_sentence.title
      expect(page).not_to have_content draft_article_with_another_sentence.title
    end
  end
end
