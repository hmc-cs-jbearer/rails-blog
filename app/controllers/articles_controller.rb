class ArticlesController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :authenticate_user!, except: [:index, :index_popular, :show, :search]

  def index
    redirect_to select_articles_path('all', 'recent')
  end

  def select
    @articles = Article.all
    @filter = params[:filter]
    @order = params[:order]

    if @filter == 'mine'
      @articles = @articles.where(user: current_user)
    end

    if @order == 'recent'
      @articles = @articles.order('created_at DESC')
    elsif @order == 'popular'
      @articles = @articles.order('upvotes_count DESC')
    else
      flash[:error] = "Unknown sorting criteria \"#{@order}\""
    end

    render 'index'
  end

  def search
    q = params[:search][:query].downcase
    @articles = Article.all.select { |article|
      article.title.downcase.include? q or article.text.downcase.include? q
    }

    if @articles.empty?
      flash[:alert] = "No results for query \"#{q}\""
    else
      flash[:success] = "We found #{pluralize(@articles.length, 'result')} matching #{q}"
    end

    render 'index'
  end

  def upvote
    @article = Article.find(params[:id])
    clear_votes(@article, current_user)
    Upvote.create(article: @article, user: @current_user)
    render 'show'
  end

  def downvote
    @article = Article.find(params[:id])
    clear_votes(@article, current_user)
    Downvote.create(article: @article, user: @current_user)
    render 'show'
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
    @article = current_user.articles.new(article_params)
    if @article.save
      flash[:success] = "Article saved."
      redirect_to @article
    else
      flash[:error] = @article.errors.full_messages
      render 'edit'
    end
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

    def clear_votes(article, user)
      Upvote.where(article: article, user: user).each do |upvote|
        upvote.destroy
      end
      Downvote.where(article: article, user: user).each do |downvote|
        downvote.destroy
      end
    end
end
