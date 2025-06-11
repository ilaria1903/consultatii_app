class Video < ApplicationRecord
  self.table_name = 'video'
  self.primary_key = 'id_video'

  belongs_to :consultatie, foreign_key: 'id_consultatie'

  validates :url_video, :video_inceput_la, :status_video, presence: true
  validate :durata_valida

  def durata_valida
    if video_incheiat_la && video_incheiat_la <= video_inceput_la
      errors.add(:video_incheiat_la, "trebuie să fie după începutul sesiunii video")
    end
  end
end
