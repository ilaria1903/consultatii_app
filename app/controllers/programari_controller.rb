class ProgramariController < ApplicationController
  # Asigura ca utilizatorul este autentificat inainte de orice actiune
  before_action :autentificare_utilizator

  # Seteaza obiectul @programare pentru metodele update si destroy
  before_action :seteaza_programare, only: [ :update, :destroy ]

  # GET /programari
  def index
    # Daca utilizatorul este medic, returneaza programarile unde el este medic
    # Altfel, returneaza programarile unde el este pacient
    programari = if current_user.rol.nume == "medic"
      Programare.where(medic_id: current_user.id)
    else
      Programare.where(pacient_id: current_user.id)
    end

    # Formateaza raspunsul JSON cu informatii suplimentare despre medic si pacient
    render json: programari.map { |p|
      {
        id: p.id,
        data_programare: p.data_programare,
        ora_programare: p.ora_programare,
        motiv: p.motiv,
        status: p.status,
        pacient_id: p.pacient_id,
        medic_id: p.medic_id,
        nume_pacient: p.pacient&.nume,
        nume_medic: p.medic&.nume,
        profil_link: "/profil.html?id=#{p.pacient_id}"
      }
    }
  end

 # POST /programari
 def create
  puts "======= PARAMS PRIMITE ======="
  pp params.to_unsafe_h
  puts "=============================="

  if current_user.rol.nume != "pacient"
    return render json: { eroare: "Doar pacientii pot crea programari" }, status: :forbidden
  end

  @programare = Programare.new(programare_params)
  @programare.pacient_id = current_user.id
  @programare.status = "pending"
  @programare.created_at = Time.now

  if !data_si_ora_in_viitor?
    return render json: { eroare: "Data sau ora nu este in viitor" }, status: :unprocessable_entity
  end

  if programare_exista?
    return render json: { eroare: "Slotul ales este deja ocupat" }, status: :unprocessable_entity
  end

  begin
    if @programare.save
      render json: @programare, status: :created
    else
      render json: { eroare: "Eroare salvare", detalii: @programare.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { eroare: "Slotul ales este deja ocupat" }, status: :unprocessable_entity
  end
 end

  # PUT /programari/:id
  def update
    # Log pentru debug
    puts " Current user: ID=#{current_user.id}, Rol=#{current_user.rol.nume}, Email=#{current_user.email}"
    puts " Programare: ID=#{@programare.id}, Medic ID=#{@programare.medic_id}"

    # Doar medicul asociat poate aproba sau respinge
    unless current_user.id == @programare.medic_id
      return render json: { eroare: "Doar medicul poate actualiza statusul" }, status: :forbidden
    end

  # Extrage noul status
  new_status = params.dig(:programare, :status) || params[:status]


    if %w[aprobata respinsa].include?(new_status)
      @programare.update(status: new_status)

      # Daca se aproba si nu exista deja o consultatie, se creeaza automat
      if new_status == "aprobata"
        unless @programare.consultatie
          Consultatie.create!(
            id_programare: @programare.id,
            start_time: Time.now,
            end_time: Time.now + 30.minutes,
            durata_minute: 30
          )
        end
      end

      render json: @programare
    else
      render json: { eroare: "Status invalid" }, status: :unprocessable_entity
    end
  end

  # DELETE /programari/:id
  def destroy
    # Verifica daca data programarii este deja trecuta
    data_ora = DateTime.new(
      @programare.data_programare.year,
      @programare.data_programare.month,
      @programare.data_programare.day,
      @programare.ora_programare.hour,
      @programare.ora_programare.min
    )

    if DateTime.now >= data_ora
      return render json: { eroare: "Nu mai poti anula o programare trecuta sau in desfasurare" }, status: :forbidden
    end

    # Permite doar pacientului sau medicului asociat sa anuleze
    if current_user.id == @programare.pacient_id || current_user.id == @programare.medic_id
      @programare.update(status: "anulata")
      render json: { mesaj: "Programarea a fost anulata." }
    else
      render json: { eroare: "Nu ai dreptul sa anulezi aceasta programare" }, status: :forbidden
    end
  end

  # Optional: actiune pentru a servi o pagina statica (probabil inutilizata)
  def creeaza
    puts "AM INTRAT IN controllerul ProgramariController#creeaza"
    render :creeaza
  end

  private

  # Permite doar campurile sigure din formular
  def programare_params
    params.require(:programare).permit(:medic_id, :data_programare, :ora_programare, :motiv)
  end

  # Cauta programarea dupa ID pentru metodele update/destroy
  def seteaza_programare
    @programare = Programare.find_by(id: params[:id])
    unless @programare
      render json: { eroare: "Programarea nu a fost gasita" }, status: :not_found
      nil
    end
  end

  # Verifica daca data + ora selectata este in viitor
  def data_si_ora_in_viitor?
    data = @programare.data_programare
    ora = @programare.ora_programare
    return false if data.nil? || ora.nil?
    DateTime.new(data.year, data.month, data.day, ora.hour, ora.min) > Time.now
  end

  # Verifica daca deja exista o programare identica pentru pacient si medic
  def programare_exista?
  Programare.exists?(
    pacient_id: current_user.id,
    medic_id: @programare.medic_id,
    data_programare: @programare.data_programare,
    ora_programare: @programare.ora_programare
  )
  end


  # Decodeaza tokenul JWT si seteaza current_user
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
