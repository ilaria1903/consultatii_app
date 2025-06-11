class Specializare < ApplicationRecord
  has_many :medici, -> { where(rol_id: Rol.find_by(nume: 'medic')&.id) }, class_name: "Utilizator"
self.table_name = "specializari"

end
