Sourcebuster::Engine.routes.draw do
	get '/', to: redirect { |params, request| "/sourcebuster/showoff#{'?' unless request.params.to_query.blank?}#{request.params.to_query}" }
	resources :referer_sources, :path => "/custom_sources"

	resources :settings, only: :update
	match '/settings', to: 'settings#index', via: :get, as: 'settings'
	match '/settings/edit', to: 'settings#edit', via: :get, as: 'edit_settings'

end
