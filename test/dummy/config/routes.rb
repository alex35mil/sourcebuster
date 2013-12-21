Rails.application.routes.draw do

  mount Sourcebuster::Engine => "/sourcebuster"

  root "static_pages#home"

end
