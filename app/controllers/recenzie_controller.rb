class RecenzieController < ApplicationController
  before_action :autentificare_utilizator

  # POST /recenzie – doar pacientul după consultație
  def create
    consultatie = Consultatie.find_by(id_consultatie: params[:id_consultatie])
    return render json: { eroare: "Consultația nu există" }, status: :not_found unless consultatie

    programare = consultatie.programare
    if current_user.cnp != programare.pacient_id
      return render json: { eroare: "Doar pacientul poate lăsa recenzie" }, status: :forbidden
    end

    if consultatie.end_time.nil?
      return render json: { eroare: "Nu poți evalua o consultație neterminată" }, status: :forbidden
    end

    if Recenzie.exists?(id_consultatie: consultatie.id_consultatie)
      return render json: { eroare: "Ai evaluat deja această consultație" }, status: :unprocessable_entity
    end

    if !(1..5).include?(params[:stele].to_i)
      return render json: { eroare: "Rating-ul trebuie să fie între 1 și 5" }, status: :unprocessable_entity
    end

    recenzie = Recenzie.new(
      id_consultatie: consultatie.id_consultatie,
      stele: params[:stele],
      rating_creat_la: Time.now
    )

    if recenzie.save
      render json: recenzie, status: :created
    else
      render json: recenzie.errors, status: :unprocessable_entity
    end
  end

  # GET /recenzii/:medic_id – listare recenzii pentru un medic
  def index
    recenzii = Recenzie.joins(:consultatie => :programare)
                       .where(programari: { medic_id: params[:medic_id] })
    render json: recenzii
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
