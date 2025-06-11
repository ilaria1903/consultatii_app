class SetariProfil < ApplicationRecord
  self.table_name = 'setari_profil'
  self.primary_key = 'utilizator_id'

  belongs_to :utilizator, foreign_key: "utilizator_id"



  validates :nume, presence: true
  validates :prenume, presence: true
  validates :data_nasterii, presence: true
end
