class SetariProfilController < ApplicationController
  before_action :autentificare_utilizator

  def show
    profil = UserProfile.find_by(utilizator_id: current_user.id)
    if profil
      render json: profil
    else
      render json: { error: "Profilul nu a fost găsit." }, status: :not_found
    end
  end

  def update
    profil = UserProfile.find_by(utilizator_id: current_user.id)
    if profil&.update(profil_params)
      render json: profil
    else
      render json: { errors: profil&.errors&.full_messages || ["Profilul nu a fost găsit."] }, status: :unprocessable_entity
    end
  end

  private

  def profil_params
    params.require(:user_profile).permit(:nume, :prenume, :data_nasterii, :gen, :istoric_diagnostic)
  end

  def autentificare_utilizator
    # logică autentificare JWT / sesiune
  end

  def current_user
    # logică extragere utilizator curent
  end
end
