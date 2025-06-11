class Chat < ApplicationRecord
  self.table_name = 'chat'
  self.primary_key = 'id_chat'

  belongs_to :consultatie, foreign_key: 'id_consultatie'

  has_many :mesaje, foreign_key: 'id_chat', dependent: :destroy
  has_many :fisiere, foreign_key: 'id_chat', dependent: :destroy

  validates :chat_inceput_la, presence: true
  validate :chat_timing

  def chat_timing
    if chat_incheiat_la && chat_inceput_la && chat_incheiat_la <= chat_inceput_la
      errors.add(:chat_incheiat_la, "trebuie să fie după începutul chatului")
    end
  end
end
