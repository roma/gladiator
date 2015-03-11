Gladiator::Application.routes.draw do
  # login
  root :to => "login#index"
  get  "login" => "login#index"
  get  "login/index"
  post "login/auth"
  get  "login/logout"

  # cluster
  get  "cluster/index"
  post "cluster/destroy"
  get  "cluster/update"
  post "cluster/release"

  # status
  get "stat/index"
  get "stat/edit"
  put "stat/update"

  # routing
  get "routing/index"
  get "routing/download"

  # logs
  get "logs/index"
  get "logs/show_logs"
  get "logs/update"

  # connection glaph
  get "connection/index"
  get "connection/show"

  # Storage
  get  "storage/index"

  # API
  get  "api/get_parameter"
  get  "api/get_parameter/:host/:port" => "api#get_parameter", :host => /.*/
  get  "api/get_routing_info"
  get  "api/get_value/:key" => "api#get_value"
  post "api/set_value"

  # 404 Error
  get  '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
  put  '*not_found' => 'application#routing_error'
end
