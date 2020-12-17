# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  category_id  :bigint
#  author_id    :bigint
#  uuid         :string(255)
#  slug         :string(255)
#  title        :string(255)
#  description  :text(65535)
#  body         :text(65535)
#  state        :integer          default("draft"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_deleted_at    (deleted_at)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#  index_articles_on_uuid          (uuid)
#

FactoryBot.define do
  factory :article do
    sequence(:title, 'title-1')
    sequence(:slug, 'slug-1')
    category
  end

  trait :future do
    published_at { DateTime.now.since(1.hours) }
    state { :publish_wait }
  end

  trait :past do
    published_at { DateTime.now.ago(1.hours) }
    state { :published }
  end

  trait :draft do
    state { :draft }
  end

  trait :with_author do
    transient do
      sequence(:author_name, 'test_author_name_1')
      sequence(:tag_slug, 'test_author_slug_1')
    end
    after(:build) do |article, evaluator|
      article.author = build(:author, name: evaluator.author_name, slug: evaluator.tag_slug)
    end
  end

  trait :with_tag do
    transient do
      sequence(:tag_name, 'test_tag_name_1')
      sequence(:tag_slug, 'test_tag_slug_1')
    end
    after(:build) do |article, evaluator|
      article.tags << build(:tag, name: evaluator.tag_name, slug: evaluator.tag_slug)
    end
  end

  trait :with_sentence do
    transient do
      sequence(:sentence_body, 'test_sentence_body_1')
    end
    after(:build) do |article, evaluator|
      article.sentences << create(:sentence, body: evaluator.sentence_body)
    end
  end
end
