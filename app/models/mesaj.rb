class Mesaj < ApplicationRecord
  self.table_name = 'mesaj'
  self.primary_key = 'id_mesaj'

  belongs_to :chat, foreign_key: 'id_chat'
  belongs_to :sender, class_name: "Utilizator", foreign_key: "sender_id"


  validates :tip_continut, inclusion: { in: %w[text fisier] }
  validates :trimis_la, presence: true
  validates :id_chat, :id_sender, presence: true
  validate :verifica_continut

  def verifica_continut
    if continut.blank? && tip_continut == 'text'
      errors.add(:continut, "nu poate fi gol pentru un mesaj text")
    end
  end
end
