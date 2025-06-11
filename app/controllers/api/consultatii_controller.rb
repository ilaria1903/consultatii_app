class Api::ConsultatiiController < ApplicationController
  before_action :autentificare_utilizator

  def index
    if current_user.rol.nume == "medic"
      # Incarcam programarile + pacientii pentru a accesa direct numele
      consultatii = Consultatie
        .includes(programare: :pacient)
        .where(programare: { medic_id: current_user.id })

      rezultat = consultatii.map do |c|
        programare = c.programare
        {
          id_consultatie: c.id_consultatie,
          data: programare.data_programare,
          ora_start: programare.ora_programare.strftime("%H:%M"),
          pacient_id: programare.pacient_id,
          nume_pacient: programare.pacient&.nume || "necunoscut",
          profil_link: "/profil.html?id=#{programare.pacient_id}"
        }
      end

      render json: rezultat

    else
      # Incarcam programarile + medicii pentru pacient
      consultatii = Consultatie
        .includes(programare: :medic)
        .where(programare: { pacient_id: current_user.id })

      rezultat = consultatii.map do |c|
        programare = c.programare
        {
          id_consultatie: c.id_consultatie,
          data: programare.data_programare,
          ora_start: programare.ora_programare.strftime("%H:%M"),
          medic_id: programare.medic_id,
          nume_medic: programare.medic&.nume || "necunoscut",
          profil_link: "/profil.html?id=#{programare.medic_id}"
        }
      end

      render json: rezultat
    end
  end
end
