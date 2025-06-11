class ChatsController < ApplicationController
  before_action :autentificare_utilizator

  # POST /chat – creează chat pentru consultație
  def create
    consultatie = Consultatie.find_by(id_consultatie: params[:id_consultatie])
    return render json: { eroare: "Consultația nu există" }, status: :not_found if consultatie.nil?

    # Doar dacă nu există deja un chat
    if Chat.exists?(id_consultatie: consultatie.id_consultatie)
      return render json: { eroare: "Chat-ul există deja" }, status: :unprocessable_entity
    end

    chat = Chat.new(
      id_consultatie: consultatie.id_consultatie,
      started_at: Time.now
    )

    if chat.save
      render json: chat, status: :created
    else
      render json: chat.errors, status: :unprocessable_entity
    end
  end

  # GET /chat/:id – doar medicul și pacientul pot vedea
  def show
    chat = Chat.find(params[:id])
    consultatie = chat.consultatie
    programare = consultatie.programare

    unless [programare.medic_id, programare.pacient_id].include?(current_user.cnp)
      return render json: { eroare: "Acces interzis la acest chat" }, status: :forbidden
    end

    render json: chat
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
