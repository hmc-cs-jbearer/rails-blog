class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles
  has_many :comments

  has_many :upvotes
  has_many :downvotes
  has_many :upvoted_articles, through: :upvotes, source: 'article'
  has_many :downvoted_articles, through: :downvotes, source: 'article'

end
