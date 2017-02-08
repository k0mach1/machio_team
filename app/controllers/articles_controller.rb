class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :confirm_permission, only: [:edit, :update, :destroy]

  def index
    # ここから新規投稿する場合にはgroup_idを渡したくないのでsessionを一旦消す
    session[:group_id] = nil
    @articles = if params[:tag]
                  Article.tagged_with(params[:tag])
                else
                  Article.all
                end
  end

  def show
    @comments = @article.comments
    @stock = Stock.new
    @article_like = ArticleLike.find_by(
      user_id: current_user.id,
      article_id: params[:article_id]
    )
  end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: '新しく投稿しました'
    else
      redirect_to root_path, alert: '新しい投稿ができませんでした'
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: '投稿を編集しました'
    else
      redirect_to @article, alert: '投稿の編集ができませんでした'
    end
  end

  def destroy
    @article.destroy
    redirect_to ''
  end

  private

  def article_params
    params.require(:article).permit(
      :title,
      :body,
      :tag_list,
      :group_id
    ).merge(user_id: current_user.id)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def confirm_permission
    redirect_to '', alert: '権限がありません' unless @article.user == current_user
  end
end
