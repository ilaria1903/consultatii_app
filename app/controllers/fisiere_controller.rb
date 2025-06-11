class FisiereController < ApplicationController
  before_action :autentificare_utilizator

  # POST /fisiere – încărcare fișier într-un chat
  def create
    chat = Chat.find_by(id_chat: params[:id_chat])
    return render json: { eroare: "Chat inexistent" }, status: :not_found unless chat

    consultatie = chat.consultatie
    programare = consultatie.programare
    unless [programare.pacient_id, programare.medic_id].include?(current_user.cnp)
      return render json: { eroare: "Nu poți încărca fișiere în acest chat" }, status: :forbidden
    end

    if params[:file_url].blank?
      return render json: { eroare: "Lipsește adresa fișierului" }, status: :unprocessable_entity
    end

    fisier = Fisier.new(
      id_utilizator: current_user.cnp,
      id_chat: chat.id_chat,
      file_url: params[:file_url],
      file_type: params[:file_type],
      nume_fisier: params[:nume_fisier],
      upload_time: Time.now
    )

    if fisier.save
      render json: fisier, status: :created
    else
      render json: fisier.errors, status: :unprocessable_entity
    end
  end

  # GET /fisiere/:chat_id – listare fișiere pentru un chat
  def index
    chat = Chat.find_by(id_chat: params[:chat_id])
    return render json: { eroare: "Chat inexistent" }, status: :not_found unless chat

    consultatie = chat.consultatie
    programare = consultatie.programare
    unless [programare.pacient_id, programare.medic_id].include?(current_user.cnp)
      return render json: { eroare: "Acces interzis" }, status: :forbidden
    end

    fisiere = Fisier.where(id_chat: chat.id_chat)
    render json: fisiere
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
