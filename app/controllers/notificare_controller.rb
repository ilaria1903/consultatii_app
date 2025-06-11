class NotificareController < ApplicationController
  before_action :autentificare_utilizator

  # GET /notificari – listare notificări proprii
  def index
    notificari = Notificare.where(id_utilizator: current_user.cnp).order(created_at: :desc)
    render json: notificari
  end

  # PUT /notificari/:id – marcare ca citit
  def update
    notificare = Notificare.find_by(id_notificare: params[:id], id_utilizator: current_user.cnp)
    return render json: { eroare: "Notificare inexistentă" }, status: :not_found unless notificare

    notificare.update(citita: true)
    render json: { mesaj: "Notificare marcată ca citită" }
  end

  private

  def autentificare_utilizator
    @current_user = Utilizator.first
  end

  def current_user
    @current_user
  end
end
