class MesajeController < ApplicationController
  before_action :autentificare_utilizator

  # POST /mesaje – trimitere mesaj într-un chat
  def create
    chat = Chat.find_by(id_chat: params[:id_chat])
    return render json: { eroare: "Chat inexistent" }, status: :not_found unless chat

    consultatie = chat.consultatie
    programare = consultatie.programare

    unless [programare.pacient_id, programare.medic_id].include?(current_user.cnp)
      return render json: { eroare: "Nu ești participant la consultație" }, status: :forbidden
    end

    # Pacientul poate trimite doar după consultatie
    if current_user.cnp == programare.pacient_id && consultatie.end_time.nil?
      return render json: { eroare: "Pacientul nu poate scrie mesaje înainte de încheierea consultației" }, status: :forbidden
    end

    if params[:continut].blank? && params[:fisier_id].blank?
      return render json: { eroare: "Mesajul trebuie să aibă conținut sau fișier" }, status: :unprocessable_entity
    end

    mesaj = Mesaj.new(
      id_chat: chat.id_chat,
      id_sender: current_user.cnp,
      continut: params[:continut],
      sent_at: Time.now,
      tip: params[:tip] || "text"
    )

    if mesaj.save
      render json: mesaj, status: :created
    else
      render json: mesaj.errors, status: :unprocessable_entity
    end
  end

  # GET /mesaje/:chat_id – listare mesaje dintr-un chat
  def index
    chat = Chat.find_by(id_chat: params[:chat_id])
    return render json: { eroare: "Chat inexistent" }, status: :not_found unless chat

    consultatie = chat.consultatie
    programare = consultatie.programare

    unless [programare.medic_id, programare.pacient_id].include?(current_user.cnp)
      return render json: { eroare: "Nu ai acces la acest chat" }, status: :forbidden
    end

    mesaje = Mesaj.where(id_chat: chat.id_chat).order(:sent_at)
    render json: mesaje
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
