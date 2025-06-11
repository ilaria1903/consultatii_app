class Utilizator < ApplicationRecord
  self.table_name = 'utilizatori'
  self.primary_key = 'id'


  #  Relații
  belongs_to :rol, class_name: 'Rol', foreign_key: 'rol_id'

  has_one :setari_profil, foreign_key: 'utilizator_id', dependent: :destroy
  has_many :programari_ca_pacient, class_name: 'Programare', foreign_key: 'pacient_id'
  has_many :programari_ca_medic, class_name: 'Programare', foreign_key: 'medic_id'
  has_many :consultatii_ca_medic, through: :programari_ca_medic, source: :consultatie
  has_many :consultatii_ca_pacient, through: :programari_ca_pacient, source: :consultatie

  has_many :mesaje_trimise, class_name: 'Mesaj', foreign_key: 'id_sender'
  has_many :fisiere_incarcate, class_name: 'Fisier', foreign_key: 'id_utilizator'
  has_many :notificari, foreign_key: 'id_utilizator'

  has_many :zile_libere, class_name: 'TimpLiberMedic', foreign_key: 'utilizator_id'
  has_many :disponibilitati, class_name: 'DisponibilitateMedic', foreign_key: 'utilizator_id'

  #Securizare parolă
  has_secure_password

  #  Validări
  validates :cnp, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  #validates :parola, presence: true; parola securizata, nu mai este vizibila
  validates :nume, presence: true
  validates :prenume, presence: true
  validates :data_nasterii, presence: true
  validates :rol_id, presence: true

    belongs_to :specializare, optional: true
end
