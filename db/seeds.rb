# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding roles..."
[ 'admin', 'medic', 'pacient' ].each do |rol_nume|
  Rol.find_or_create_by(nume: rol_nume)
end
puts "Creating first admin..."
admin_role = Rol.find_by(nume: 'admin')

if admin_role.nil?
  raise "Rolul 'admin' nu există! Verifică ordinea în seeds.rb."
end

Utilizator.find_or_create_by(email: ENV["ADMIN_EMAIL"]) do |admin|
  admin.password = ENV["ADMIN_PASSWORD"]
  admin.rol_id = admin_role.id
  admin.cnp = ENV["ADMIN_CNP"]
  admin.data_inregistrare = Date.today
  admin.data_nasterii = Date.new(1990, 1, 1)
  admin.nume = "Moroianu"
  admin.prenume = "Alexia"
end

puts "Creating pacient de test..."
pacient_role = Rol.find_by(nume: 'pacient')

Utilizator.find_or_create_by(email: ENV["PACIENT_EMAIL"]) do |pacient|
  pacient.password = ENV["PACIENT_PASSWORD"]
  pacient.rol_id = pacient_role.id
  pacient.cnp = ENV["PACIENT_CNP"]
  pacient.data_inregistrare = Date.today
  pacient.data_nasterii = Date.new(2000, 5, 10)
  pacient.nume = "Popescu"
  pacient.prenume = "Ioana"
end

puts "Creating medic de test..."
medic_role = Rol.find_by(nume: 'medic')

Utilizator.find_or_create_by(email: ENV["MEDIC_EMAIL"]) do |medic|
  medic.password = ENV["MEDIC_PASSWORD"]
  medic.rol_id = medic_role.id
  medic.cnp = ENV["MEDIC_CNP"]
  medic.data_inregistrare = Date.today
  medic.data_nasterii = Date.new(1985, 3, 20)
  medic.nume = "Ionescu"
  medic.prenume = "Andrei"
end



puts "Seeding specializări..."

[
  "Cardiologie",
  "Dermatologie",
  "Endocrinologie",
  "Gastroenterologie",
  "Ginecologie",
  "Neurologie",
  "Ortopedie",
  "Pediatrie",
  "Psihiatrie",
  "Urologie"
].each do |nume|
  Specializare.find_or_create_by(nume: nume)
end
