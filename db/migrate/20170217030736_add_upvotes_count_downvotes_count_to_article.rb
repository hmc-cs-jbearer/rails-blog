class AddUpvotesCountDownvotesCountToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :upvotes_count, :integer
    add_column :articles, :downvotes_count, :integer
  end
end
