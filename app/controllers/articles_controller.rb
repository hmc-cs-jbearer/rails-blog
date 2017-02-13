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
      redirect_to articles_path
    end
  end

  def create
    @article = current_user.articles.create(article_params)
    redirect_to @article
  end

  def update
    @article = Article.find(params[:id])
    if @article.user != current_user
      redirect_to articles_path
    elsif @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user != current_user
      redirect_to articles_path
    else
      @article = Article.find(params[:id])
      @article.destroy
      redirect_to articles_path
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
