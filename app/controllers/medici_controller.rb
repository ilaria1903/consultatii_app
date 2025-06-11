class MediciController < ApplicationController
  skip_before_action :autentificare_utilizator

  def zile_disponibile
    medic = Utilizator.find_by(id: params[:id])
    luna = params[:luna].to_i
    an = Time.zone.now.year

    return render json: [] unless medic

    zile = []

    # presupunem lunile 0-indexed (0 = Ianuarie, 7 = August)
    start_date = Date.new(an, luna + 1, 1)
    end_date = start_date.end_of_month

    (start_date..end_date).each do |data|
      next unless (1..5).include?(data.wday) # Luni–Vineri

      e_zi_libera = TimpLiberMedic.exists?(utilizator_id: medic.id, zi: data)


      programari_in_zi = Programare.where(
        medic_id: medic.id,
        data_programare: data
      ).where.not(status: "anulata").pluck(:ora_programare)

      toate_orele = (10..16).to_a
      ore_ocupate = programari_in_zi.map { |o| o.hour }
      ore_libere = toate_orele - ore_ocupate

      zile << data.day if !e_zi_libera && ore_libere.any?
    end

    render json: zile
  end

  def ore_disponibile
    medic = Utilizator.find_by(id: params[:id])
    zi = params[:zi].to_i
    luna = params[:luna].to_i
    an = Time.zone.now.year

    return render json: [] unless medic

    data = Date.new(an, luna + 1, zi)
    zi_saptamana = data.wday
    return render json: [] unless (1..5).include?(zi_saptamana)

    if TimpLiberMedic.exists?(utilizator_id: medic.id, zi: data)

      return render json: []
    end

    programari = Programare.where(medic_id: medic.id, data_programare: data)
                           .where.not(status: "anulata")
                           .pluck(:ora_programare)

    ore_ocupate = programari.map { |o| o.strftime("%H:%M") }
    ore_disponibile = (10..16).map { |h| "#{h}:00" } - ore_ocupate

    render json: ore_disponibile
  end
end
