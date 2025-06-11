class Consultatie < ApplicationRecord
  self.table_name = 'consultatie'
  self.primary_key = 'id_consultatie'

  belongs_to :programare, foreign_key: "id_programare"
  has_one :chat, foreign_key: 'id_consultatie', dependent: :destroy
  has_one :video, foreign_key: 'id_consultatie', dependent: :destroy
  has_one :recenzie, foreign_key: 'id_consultatie', dependent: :destroy
  has_one :plata, foreign_key: 'id_consultatie', dependent: :destroy

  validates :start_time, :end_time, :durata_minute, presence: true
  validate :durata_si_interval_corect

  def durata_si_interval_corect
    if end_time && start_time && end_time <= start_time
      errors.add(:end_time, "trebuie să fie după start_time")
    end
    if durata_minute && (durata_minute < 1 || durata_minute > 30)
      errors.add(:durata_minute, "trebuie să fie între 1 și 30 de minute")
    end
  end
end
