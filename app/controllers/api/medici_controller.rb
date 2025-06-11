class Api::MediciController < ApplicationController
  before_action :autentificare_utilizator

  # GET /api/medici/:id/zile_disponibile
  def zile_disponibile
    medic = Utilizator.find(params[:id])
    azi = Date.today
    anul = azi.year

    zile_sapt = DisponibilitateMedic.where(utilizator_id: medic.id).pluck(:zi_saptamana)
    zile_libere = TimpLiberMedic.where(utilizator_id: medic.id).pluck(:zi)
    programari = Programare.where(medic_id: medic.id, status: 'aprobat')
    date_ocupate = programari.map(&:data_programare)
    toate_zilele = (azi..Date.new(anul, 12, 31)).to_a

    zile_disponibile = toate_zilele.select do |zi|
      zile_sapt.include?(zi.wday) &&
      !zile_libere.include?(zi) &&
      !date_ocupate.include?(zi)
    end

    render json: { zile: zile_disponibile }
  end

  # GET /api/medici/:id/ore_disponibile?zi=2025-06-18
  def ore_disponibile
    medic = Utilizator.find(params[:id])
    zi = Date.parse(params[:zi]) rescue nil
    return render json: { eroare: "Zi invalidă" }, status: :bad_request unless zi

    zi_saptamana = zi.wday
    lucreaza = DisponibilitateMedic.exists?(utilizator_id: medic.id, zi_saptamana: zi_saptamana)
    return render json: { ore: [] } unless lucreaza

    return render json: { ore: [] } if TimpLiberMedic.exists?(utilizator_id: medic.id, zi: zi)

    ore_standard = (10..16).map { |h| "#{h}:00" }
    ore_ocupate = Programare.where(medic_id: medic.id, data_programare: zi).pluck(:ora_programare)
    ore_ocupate_formatate = ore_ocupate.map { |o| o.strftime("%H:%M") }

    ore_libere = ore_standard - ore_ocupate_formatate

    render json: { ore: ore_libere }
  end
end
