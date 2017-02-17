class Downvote < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true
end
