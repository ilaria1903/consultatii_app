class PlatiController < ApplicationController
  before_action :autentificare_utilizator

  # POST /plati – doar pacientul plătește, după încheierea consultației
  def create
    consultatie = Consultatie.find_by(id_consultatie: params[:id_consultatie])
    return render json: { eroare: "Consultația nu există" }, status: :not_found unless consultatie

    programare = consultatie.programare
    if current_user.cnp != programare.pacient_id
      return render json: { eroare: "Doar pacientul poate plăti consultația" }, status: :forbidden
    end

    if consultatie.end_time.nil?
      return render json: { eroare: "Consultația nu s-a încheiat încă" }, status: :forbidden
    end

    if Plata.exists?(id_consultatie: consultatie.id_consultatie)
      return render json: { eroare: "Consultația a fost deja plătită" }, status: :unprocessable_entity
    end

    if params[:suma].to_f <= 0
      return render json: { eroare: "Suma trebuie să fie mai mare decât 0" }, status: :unprocessable_entity
    end

    metode_valide = %w[card cash transfer]
    unless metode_valide.include?(params[:metoda])
      return render json: { eroare: "Metodă de plată invalidă" }, status: :unprocessable_entity
    end

    plata = Plata.new(
      id_consultatie: consultatie.id_consultatie,
      platitor_id: current_user.cnp,
      suma: params[:suma],
      metoda: params[:metoda],
      status: "platita",
      data_plata: Time.now
    )

    if plata.save
      render json: plata, status: :created
    else
      render json: plata.errors, status: :unprocessable_entity
    end
  end

  # GET /plati/:id_consultatie – doar participanții pot vedea
  def show
    plata = Plata.find_by(id_consultatie: params[:id_consultatie])
    return render json: { eroare: "Plata nu există" }, status: :not_found unless plata

    consultatie = plata.consultatie
    programare = consultatie.programare
    unless [programare.pacient_id, programare.medic_id].include?(current_user.cnp)
      return render json: { eroare: "Nu ai acces la această plată" }, status: :forbidden
    end

    render json: plata
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
