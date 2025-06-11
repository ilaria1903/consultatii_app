class UtilizatoriController < ApplicationController
  # Autentifica utilizatorul pentru toate actiunile, cu exceptia create (inregistrare publica)
  before_action :autentificare_utilizator, except: [ :create ]

  # Cauta utilizatorul in baza de date pe baza id-ului pentru metodele show, update si destroy
  before_action :seteaza_utilizator, only: [ :show, :update, :destroy ]

  def index
    utilizatori = Utilizator.all
    render json: utilizatori
  end


  def show
    render json: @utilizator
  end


 def create
  pacient_role = Rol.find_by(nume: "pacient")

  if pacient_role.nil?
    render json: { error: "Rolul 'pacient' nu a fost găsit în baza de date." }, status: :unprocessable_entity
    return
  end

  utilizator = Utilizator.new(utilizator_params.merge(rol_id: pacient_role.id))

  if utilizator.save
    render json: utilizator, status: :created
  else
    render json: { errors: utilizator.errors.full_messages }, status: :unprocessable_entity
  end
 end



  def update
    if @utilizator.id != current_user.id
      render json: { error: "Nu aveți permisiunea să modificați acest utilizator." }, status: :forbidden
    elsif @utilizator.update(utilizator_params)
      render json: @utilizator
    else
      render json: { errors: @utilizator.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    if @utilizator.id != current_user.id
      render json: { error: "Nu aveți permisiunea să ștergeți acest utilizator." }, status: :forbidden
    else
      @utilizator.destroy
      head :no_content
    end
  end


  # Returneaza datele profilului utilizatorului logat
  def profil
  render json: {
    id: current_user.id,
    email: current_user.email,
    nume: current_user.nume,
    prenume: current_user.prenume,
    rol: current_user.rol.nume
  }
  end


  def medici_din_specializare
  medici = Utilizator.where(rol_id: Rol.find_by(nume: "medic").id, specializare_id: params[:id])
  render json: medici
  end


# Trimite fisierul profil.html (pagina HTML pentru afisarea profilului)
def profil_utilizator
  send_file Rails.root.join("public", "profil.html")
end

def dashboard_pacient
  send_file Rails.root.join("public", "utilizator.html")
end

def dashboard_medic
  send_file Rails.root.join("public", "utilizator_medic.html") # pagina HTML dedicată medicului
end


 def medici
  rol = Rol.find_by(nume: "medic")
  unless rol
    render json: { error: "Rolul 'medic' nu există" }, status: :not_found and return
  end

  medici = Utilizator.where(rol_id: rol.id)
  render json: medici end

  def pacienti
  rol = Rol.find_by(nume: "pacient")
  if rol.nil?
    render json: { error: "Rolul 'pacient' nu există." }, status: :not_found
    return
  end

  pacienti = Utilizator.where(rol_id: rol.id)
  render json: pacienti
  end


  private

  # Filtreaza parametrii acceptati din formular (doar cei permisi pentru creare/update)
  def utilizator_params
  params.require(:utilizator).permit(:email, :password, :password_confirmation, :nume, :prenume, :cnp, :data_nasterii)
    # Only allow safe fields
  end


  # Cauta utilizatorul dupa id si seteaza @utilizator
  def seteaza_utilizator
    @utilizator = Utilizator.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Utilizatorul nu a fost găsit." }, status: :not_found
  end
end
