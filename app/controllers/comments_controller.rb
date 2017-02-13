class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    # A comment can be deleted by the author of the comment or of the article
    if current_user == @comment.user or current_user == @article.user
      flash[:success] = 'Comment deleted.'
      @comment.destroy
      redirect_to article_path(@article)
    else
      flash[:error] = 'You do not have permission to delete this comment.'
      redirect_to article_path(@article)
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body).merge(user_id: current_user.id)
    end
end
