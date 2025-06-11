class SpecializariController < ApplicationController
  before_action :autentificare_utilizator

  def index
    specializari = Specializare.all
    render json: specializari
  end
end
