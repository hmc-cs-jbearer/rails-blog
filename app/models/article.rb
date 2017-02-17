class Article < ApplicationRecord
    has_many :comments, dependent: :destroy
    belongs_to :user

    has_many :upvotes
    has_many :downvotes
    has_many :upvote_users, through: :upvotes, source: 'user'
    has_many :downvote_users, through: :downvotes, source: 'user'

    validates :title,
        presence: true,
        length: { minimum: 5 }
end
