class Recenzie < ApplicationRecord
  self.table_name = 'recenzie'
  self.primary_key = 'id_recenzie'

  belongs_to :consultatie, foreign_key: 'id_consultatie'

  validates :nr_stele, presence: true, inclusion: { in: 1..5 }
  validates :id_consultatie, uniqueness: true
end
