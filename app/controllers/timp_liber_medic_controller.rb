class TimpLiberMedicController < ApplicationController
  # Asigura ca utilizatorul este autentificat inainte de orice actiune
  before_action :autentificare_utilizator

  # Seteaza @timp_liber pentru actiunea destroy (folosind ID-ul din params)
  before_action :seteaza_timp_liber, only: [:destroy]

  # GET /timp_liber_medic
  # Returneaza toate zilele libere ale medicului curent
  def index
    timp_liber = TimpLiberMedic.where(user_id: current_user.id)
    render json: timp_liber
  end

  # POST /timp_liber_medic
  # Creeaza o noua zi libera pentru medicul curent
  def create
    timp_liber = TimpLiberMedic.new(timp_liber_params)
    timp_liber.user_id = current_user.id

    if timp_liber.save
      render json: timp_liber, status: :created
    else
      # Daca exista erori (ex: zi deja declarata), returneaza mesajele de eroare
      render json: { errors: timp_liber.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /timp_liber_medic/:id
  # Sterge o zi libera, doar daca apartine medicului curent
  def destroy
    if @timp_liber.user_id == current_user.id
      @timp_liber.destroy
      head :no_content # Returneaza 204 fara continut
    else
      # Daca altcineva incearca sa stearga o intrare care nu ii apartine
      render json: { error: "Nu aveti permisiunea sa stergeti aceasta intrare." }, status: :forbidden
    end
  end

  private

  # Permite doar parametrul :data pentru a fi primit din formular
  def timp_liber_params
    params.require(:timp_liber_medic).permit(:data)
  end

  # Gaseste inregistrarea TimpLiberMedic dupa ID
  def seteaza_timp_liber
    @timp_liber = TimpLiberMedic.find(params[:id])
  end

  # Placeholder: metoda care autentifica utilizatorul (JWT sau sesiune)
  def autentificare_utilizator
    # logica ta de autentificare
  end

  # Placeholder: metoda care returneaza utilizatorul curent logat
  def current_user
    # logica ta pentru utilizator curent
  end
end
