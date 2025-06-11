# === app/controllers/application_controller.rb ===
class ApplicationController < ActionController::API
  # Executa metoda de autentificare inainte de orice actiune din controllerele care mostenesc acest controller
  before_action :autentificare_utilizator

  # Extrage tokenul JWT din header si seteaza utilizatorul curent
  def autentificare_utilizator
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = Utilizator.find(decoded["utilizator_id"])
    rescue
      render json: { error: "Token invalid sau lipsă" }, status: :unauthorized
    end
  end

  # Returneaza utilizatorul curent autentificat
  def current_user
    @current_user
  end

  # Permite accesul doar adminilor
  def verifica_admin
    unless current_user&.rol_id == Rol.find_by(nume: 'admin')&.id
      render json: { error: "Acces interzis. Doar administratorii au permisiunea." }, status: :forbidden
    end
  end

  # Permite accesul doar medicilor
  def verifica_medic
    unless current_user&.rol_id == Rol.find_by(nume: 'medic')&.id
      render json: { error: "Acces interzis. Doar medicii au permisiunea." }, status: :forbidden
    end
  end

  # Permite accesul doar pacientilor
  def verifica_pacient
    unless current_user&.rol_id == Rol.find_by(nume: 'pacient')&.id
      render json: { error: "Acces interzis. Doar pacienții au permisiunea." }, status: :forbidden
    end
  end

  private

  # Metoda privata pentru obtinerea utilizatorului curent
  def current_user
    @current_user
  end

  # Metoda privata pentru autentificarea prin JWT
  def autentificare_utilizator
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = Utilizator.find(decoded["utilizator_id"])
    rescue
      render json: { error: "Token invalid sau lipsă" }, status: :unauthorized
    end
  end
end