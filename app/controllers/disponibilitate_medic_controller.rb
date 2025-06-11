class DisponibilitateMedicController < ApplicationController
  before_action :autentificare_utilizator
  before_action :verifica_medic

  def index
    disponibilitati = DisponibilitateMedic.all
    render json: disponibilitati
  end
end
