class Admin::UtilizatoriController < ApplicationController
  before_action :autentificare_utilizator
  before_action :verifica_admin

  def create
    rol = Rol.find_by(id: params[:utilizator][:rol_id])

    return render json: { error: "Rol invalid" }, status: :unprocessable_entity if rol.nil?

utilizator = Utilizator.new(utilizator_params)
utilizator.rol_id = rol.id


    if utilizator.save
      render json: utilizator, status: :created
    else
      render json: { errors: utilizator.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
  utilizator = Utilizator.find_by(id: params[:id])
  return render json: { error: "Utilizatorul nu există" }, status: :not_found unless utilizator

  if utilizator.update(utilizator_params)
    render json: utilizator
  else
    render json: { errors: utilizator.errors.full_messages }, status: :unprocessable_entity
  end
  end
  
  private

  def utilizator_params
    params.require(:utilizator).permit(:email, :password, :nume, :prenume, :cnp, :data_nasterii, :specializare_id)
  end

  def verifica_admin
    unless current_user && current_user.rol.nume == 'admin'
      render json: { error: "Acces interzis. Doar adminii pot efectua această acțiune." }, status: :forbidden
    end
  end

  

end
