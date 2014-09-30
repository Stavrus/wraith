Rails.application.routes.draw do

  root 'static#index'

  devise_for :users

  namespace 'api' do
    namespace 'v1' do

      match 'auth/sign_in', to: 'sessions#authorize', via: [:post]
      match 'auth/profile', to: 'sessions#profile', via: [:get]
      match 'auth/sign_out', to: 'sessions#destroy', via: [:delete]

      match 'matches/active', to: 'matches#active', via: [:get]
      resources :matches, :except => [:new, :edit, :destroy]
      match 'matches/:id', to: 'matches#update', via: [:options]

      match 'antiviri/use', to: 'matches#use', via: [:post]
      resources :antiviri, :except => [:new, :edit, :destroy]
      match 'antiviri/:id', to: 'antiviri#update', via: [:options]

      resources :badges, :except => [:new, :edit, :destroy]
      match 'badges/:id', to: 'badges#update', via: [:options]

      resources :badge_users, :except => [:new, :edit, :destroy]
      match 'badge_users/:id', to: 'badge_users#update', via: [:options]

      resources :clans, :except => [:new, :edit, :destroy]
      match 'clans/:id', to: 'clans#update', via: [:options]
      match 'clans/:id/leave', to: 'clans#leave', via: [:post]
      match 'clans/:id/invite', to: 'clans#invite', via: [:post]
      match 'clans/:id/kick', to: 'clans#kick', via: [:post]

      resources :clan_invites, :except => [:new, :edit, :update, :destroy]
      match 'clan_invites/:id', to: 'clan_invites#update', via: [:options]
      match 'clan_invites/:id/accept', to: 'clan_invites#accept', via: [:post]

      resources :missions, :except => [:new, :edit, :destroy]
      match 'missions/:id', to: 'missions#update', via: [:options]

      resources :tags, :except => [:new, :edit, :destroy]
      match 'tags/:id', to: 'tags#update', via: [:options]

      resources :teams, :except => [:new, :edit, :destroy]
      match 'teams/:id', to: 'teams#update', via: [:options]

      resources :tiers, :except => [:new, :edit, :destroy]
      match 'tiers/:id', to: 'tiers#update', via: [:options]
      match 'tiers/:id/vote', to: 'tiers#vote', via: [:post]

      match 'users/register', to: 'users#register', via: [:post]
      resources :users, :only => [:index, :show, :update]
      match 'users/:id', to: 'users#update', via: [:options]

      match 'match_users/print', to: 'match_users#print', via: [:post]
      resources :match_users, :only => [:index, :show, :update]
      match 'match_users/:id', to: 'match_users#update', via: [:options]
    end
  end
end
