class Fisier < ApplicationRecord
  self.table_name = 'fisier'
  self.primary_key = 'id_fisier'

  belongs_to :chat, foreign_key: 'id_chat'
  belongs_to :utilizator, foreign_key: "utilizator_id"



  validates :file_url, :nume_fisier, presence: true
end
