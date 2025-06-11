class Notificare < ApplicationRecord
  self.table_name = 'notificare'
  self.primary_key = 'id_notificare'

  belongs_to :utilizator, foreign_key: "id_utilizator", primary_key: "cnp"


  validates :continut_notificare, presence: true
end
