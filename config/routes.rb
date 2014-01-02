Sourcebuster::Engine.routes.draw do
	get '/', to: redirect { |params, request| "/sourcebuster/showoff#{'?' unless request.params.to_query.blank?}#{request.params.to_query}" }
	resources :referer_sources
end
