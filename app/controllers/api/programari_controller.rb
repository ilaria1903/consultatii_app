# app/controllers/api/programari_controller.rb
class Api::ProgramariController < ApplicationController
  before_action :autentificare_utilizator


def index
  programari = if current_user.rol.nume == "medic"
    Programare.where(medic_id: current_user.id)
  else
    Programare.where(pacient_id: current_user.id)
  end

  render json: programari.map { |p|
    {
      id: p.id,
      data_programare: p.data_programare,
      ora_programare: p.ora_programare,
      motiv: p.motiv,
      status: p.status,
      pacient_id: p.pacient_id,
      medic_id: p.medic_id,
      nume_pacient: p.pacient&.nume,
      nume_medic: p.medic&.nume,
      profil_link: "/profil.html?id=#{p.pacient_id}"
    }
  }
end


  def show
  programare = Programare.find_by(id: params[:id])

  if programare.nil? || programare.pacient_id != @current_user.id
    render json: { error: "Programare inexistentă sau acces interzis" }, status: :not_found
    return
  end

  render json: {
    id: programare.id,
    data_programare: programare.data_programare,
    ora_programare: programare.ora_programare,
    status: programare.status,
    motiv: programare.motiv,
    created_at: programare.created_at
  }
  end

end



