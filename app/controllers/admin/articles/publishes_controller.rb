class Admin::Articles::PublishesController < ApplicationController
  layout 'admin'

  before_action :set_article

  def update
    if @article.published_at.to_time > Time.current # 未来の記事
      @article.publish_wait!
      flash[:notice] = '記事を公開待ちにしました'
      redirect_to edit_admin_article_path(@article.uuid)
    else # 過去の記事
      @article.published_at = Time.current unless @article.published_at?
      @article.published!

      if @article.valid?
        Article.transaction do
          @article.body = @article.build_body(self)
          @article.save!
        end

        flash[:notice] = '記事を公開しました'

        redirect_to edit_admin_article_path(@article.uuid)
      else
        flash.now[:alert] = 'エラーがあります。確認してください。'

        @article.state = @article.state_was if @article.state_changed?
        render 'admin/articles/edit'
      end
    end
  end

  private

  def set_article
    @article = Article.find_by!(uuid: params[:article_uuid])
  end
end
