class Rol < ApplicationRecord
  self.table_name = 'roluri'
 

  has_many :utilizatori, foreign_key: 'rol_id'

  validates :nume, presence: true, inclusion: { in: %w[admin medic pacient] }
end
