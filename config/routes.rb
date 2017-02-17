Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'

  get 'articles/mine', to: 'articles#mine', as: 'user_articles'
  post 'articles/search', to: 'articles#search', as: 'search_articles'

  get 'articles/:id/upvote', to: 'articles#upvote', as: 'upvote_article'
  get 'articles/:id/downvote', to: 'articles#downvote', as: 'downvote_article'

  resources :articles do
    resources :comments
  end

  root 'articles#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
