class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles = Article.all
  end

  def mine
    @articles = current_user.articles
    render 'index'
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    if @article.user != current_user
      flash[:error] = "You do not have permission to edit this article."
      redirect_to @article
    end
  end

  def create
    @article = current_user.articles.create(article_params)
    redirect_to @article
  end

  def update
    @article = Article.find(params[:id])
    if @article.user != current_user
      flash[:error] = "You do not have permission to edit this article."
      redirect_to @article
    elsif @article.update(article_params)
      flash[:success] = "Article updated."
      redirect_to @article
    else
      flash[:error] = @article.errors.full_messages
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user != current_user
      flash[:error] = "You do not have permission to delete this article."
      redirect_to @article
    else
      @article = Article.find(params[:id])
      @article.destroy

      flash[:success] = "Article deleted."
      redirect_to articles_path
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
