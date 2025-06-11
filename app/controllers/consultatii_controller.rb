class ConsultatiiController < ApplicationController
  before_action :autentificare_utilizator
  before_action :seteaza_consultatie, only: [ :show ]

  # GET /consultatii – doar consultațiile proprii (medic/pacient)
  def index
    consultatii = if current_user.rol.nume == "medic"
      Consultatie.includes(:programare)
                 .where(programare: { medic_id: current_user.id })
    else
      Consultatie.includes(:programare)
                 .where(programare: { pacient_id: current_user.id })
    end

    rezultat = consultatii.map do |c|
      programare = c.programare
      {
        id_consultatie: c.id_consultatie,
        data: programare.data_programare,
        ora_start: programare.ora_programare.strftime("%H:%M"),
        pacient_id: programare.pacient_id,
        profil_link: "/profil.html?id=#{programare.pacient_id}"
      }
    end

    render json: rezultat
  end

  # POST /consultatii – doar backendul/medicul creează (nu pacientul direct)
  def create
    programare = Programare.find_by(id: params[:id_programare], status: "aprobata")

    if programare.nil?
      return render json: { eroare: "Programarea nu este validă sau aprobată" }, status: :unprocessable_entity
    end

    datetime_programare = DateTime.new(
      programare.data_programare.year,
      programare.data_programare.month,
      programare.data_programare.day,
      programare.ora_programare.hour,
      programare.ora_programare.min
    )

    if Time.now < datetime_programare
      return render json: { eroare: "Consultația nu poate fi creată înainte de ora programării" }, status: :forbidden
    end

    consultatie = Consultatie.new(
      id_programare: programare.id,
      start_time: Time.now,
      end_time: Time.now + 30.minutes,
      durata_minute: 30
    )

    if consultatie.save
      render json: consultatie, status: :created
    else
      render json: consultatie.errors, status: :unprocessable_entity
    end
  end

  # GET /consultatii/:id – vizualizare doar dacă participi
  def show
    programare = @consultatie.programare

    unless [ programare.pacient_id, programare.medic_id ].include?(current_user.id)
      return render json: { eroare: "Nu ai acces la această consultație" }, status: :forbidden
    end

    render json: @consultatie
  end

  # GET /consultatii/auto_create – doar pentru test/demo/backoffice
  def auto_create
    programari = Programare.where(status: "aprobata").select do |prog|
      datetime = DateTime.new(
        prog.data_programare.year,
        prog.data_programare.month,
        prog.data_programare.day,
        prog.ora_programare.hour,
        prog.ora_programare.min
      )
      datetime < Time.now
    end

    create_count = 0

    programari.each do |programare|
      unless Consultatie.exists?(id_programare: programare.id)
        Consultatie.create!(
          id_programare: programare.id,
          start_time: Time.now,
          end_time: Time.now + 30.minutes,
          durata_minute: 30
        )
        create_count += 1
      end
    end

    render json: { mesaj: "Consultații create automat: #{create_count}" }
  end

  private

  def seteaza_consultatie
    @consultatie = Consultatie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { eroare: "Consultația nu a fost găsită" }, status: :not_found
  end

  def autentificare_utilizator
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = Utilizator.find(decoded["utilizator_id"])
    rescue
      render json: { error: "Token invalid" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
