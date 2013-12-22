Sourcebuster::Engine.routes.draw do
	get '/', to: redirect { |params, request| "/sourcebuster/showoff#{'?' unless request.params.to_query.blank?}#{request.params.to_query}" }
	get '/showoff', to: 'cookie_setters#showoff', as: 'showoff'
end
