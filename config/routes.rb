Rails.application.routes.draw do
  get "/utilizatori/medici", to: "utilizatori#medici"
  get "/utilizatori/pacienti", to: "utilizatori#pacienti"
  get "specializari/index"
    # === UTILIZATORI ===
    resources :utilizatori, only: [ :index, :show, :create, :update, :destroy ]

    # === SETĂRI PROFIL (user_profile) ===
    resources :setari_profil, only: [ :show, :update ]

    # === PROGRAMARI ===
    resources :programari, only: [ :index, :create, :update, :destroy ]

    # === CONSULTATII ===
    resources :consultatii, only: [ :index, :show, :create ]

    # === CHAT ===
    resources :chat, only: [ :show, :create ]

    # === MESAJE ===
    resources :mesaje, only: [ :index, :create ]

    # === PLATI ===
    resources :plati, only: [ :create ]
    get "/plati/:id_consultatie", to: "plati#show"

    # === RECENZII ===
    post "/recenzie", to: "recenzie#create"
    get "/recenzii/:medic_id", to: "recenzie#index"

    # === FISIERE ===
    resources :fisiere, only: [ :create ]
    get "/fisiere/:chat_id", to: "fisiere#index"

    # === NOTIFICARI ===
    resources :notificari, only: [ :index, :update ]

    # === DISPONIBILITATE MEDIC ===
    resources :disponibilitate_medic, only: [ :index ]

    # === TIMP LIBER MEDIC ===
    resources :timp_liber_medic, only: [ :index, :create, :destroy ]

    # === ROOT PATH (opțional) ===
    root to: "utilizatori#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
get "/utilizator_profil", to: "utilizatori#profil"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :admin do
    resources :utilizatori, only: [ :create, :update ]
  end


  post "/login", to: "autentificari#create"
delete "/logout", to: "autentificari#destroy"


post "/autentificari", to: "autentificari#create"
namespace :api do
  # === AUTENTIFICARE ===
  post "login", to: "autentificari#login"
  get "current_user", to: "utilizator#current"

  # === PROGRAMARI ===
  resources :programari, only: [ :index, :show, :update, :destroy ]

  # === CONSULTATII ===
  resources :consultatii, only: [ :index ]
  get "consultatii/auto_create", to: "consultatii#auto_create"

  # === MEDICI ===
  resources :medici, only: [] do
    member do
      get "zile_disponibile"
      get "ore_disponibile"
    end
  end

  # === UTILIZATOR ===
  get "/utilizator/:id", to: "utilizator#show"
  get "utilizator/info", to: "utilizator#info"
  get "/profil_utilizator", to: "utilizator#profil_utilizator"
  get "/dashboard_pacient", to: "utilizatori#dashboard_pacient"
  get "/utilizator_medic", to: "utilizatori#dashboard_medic"

  # === EVALUARI ===
  post "evaluari", to: "evaluari#create"
end


get "/specializari", to: "specializari#index"

get "medici/:id/zile_disponibile", to: "medici#zile_disponibile"

get "/creeaza_programare", to: "programari#creeaza"

get "/medici_din_specializare/:id", to: "utilizatori#medici_din_specializare"

get "/medici/:id/ore_disponibile", to: "medici#ore_disponibile"
end
