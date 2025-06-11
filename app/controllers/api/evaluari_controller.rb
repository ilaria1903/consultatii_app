# app/controllers/api/evaluari_controller.rb
class Api::EvaluariController < ApplicationController
before_action :autentificare_utilizator


  def create
    consultatie = Consultatie.find(params[:consultatie_id])
    return render json: { error: "Acces interzis" }, status: :forbidden unless consultatie.programare.pacient_id == @current_user.id

    evaluare = RatingMedic.new(
      consultatie_id: consultatie.id,
      stele: params[:stele].to_i
    )

    if evaluare.save
      render json: { success: true }
    else
      render json: { error: "Eroare salvare evaluare" }, status: :unprocessable_entity
    end
  end
end
