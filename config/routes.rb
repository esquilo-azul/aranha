Aranha::Engine.routes.draw do
  resources(:addresses) { as_routes }
end
