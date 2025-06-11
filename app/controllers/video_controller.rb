class VideoController < ApplicationController
  before_action :autentificare_utilizator
  before_action :seteaza_sesiune_video, only: [:show]

  def create
    sesiune = Video.new(video_params)

    if sesiune.save
      render json: sesiune, status: :created
    else
      render json: { errors: sesiune.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @sesiune
  end

  private

  def video_params
    params.require(:video).permit(:consultatie_id, :video_url, :ora_inceput, :ora_sfarsit, :status)
  end

  def seteaza_sesiune_video
    @sesiune = Video.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Sesiunea video nu a fost găsită." }, status: :not_found
  end

  def autentificare_utilizator
    # logică de autentificare
  end

  def current_user
    # logica de identificare a utilizatorului curent
  end
end
