class Api::UtilizatorController < ApplicationController
  # Asigura ca toate metodele din acest controller sunt accesibile doar utilizatorilor autentificati
  before_action :autentificare_utilizator

  # Returneaza datele utilizatorului logat (extras din token)
  def current
    render json: {
      id: current_user.id,
      email: current_user.email,
      nume: current_user.nume,
      prenume: current_user.prenume,
      rol: current_user.rol.nume
    }
  end

  # Acelasi lucru ca metoda 'current' - returneaza informatii despre utilizatorul curent
  def profil_utilizator
    render json: {
      id: current_user.id,
      email: current_user.email,
      nume: current_user.nume,
      prenume: current_user.prenume,
      rol: current_user.rol.nume
    }
  end

  # Returneaza informatii despre un utilizator identificat prin ID
  def show
    utilizator = Utilizator.find(params[:id]) # Cauta utilizatorul in DB dupa ID
    profil = utilizator.setari_profil        # Incarca profilul extins (daca exista)
    rol = utilizator.rol                      # Incarca rolul asociat

    # Construieste raspunsul JSON cu datele relevante
    render json: {
      id: utilizator.id,
      email: utilizator.email,
      nume: utilizator.nume,
      prenume: utilizator.prenume,
      rol: rol&.nume || "necunoscut",             # Foloseste "necunoscut" daca nu are rol
      data_nasterii: profil&.data_nasterii,       # Foloseste nil daca nu are profil extins
      gen: profil&.gen
    }
  rescue ActiveRecord::RecordNotFound
    # Daca nu gaseste utilizatorul, returneaza 404 cu mesaj corespunzator
    render json: { eroare: "Utilizatorul nu a fost gasit" }, status: :not_found
  rescue => e
    # In caz de eroare neprevazuta, logheaza eroarea si returneaza 500
    Rails.logger.error("Eroare profil utilizator: #{e.message}")
    render json: { eroare: "Eroare interna server" }, status: :internal_server_error
  end
end
