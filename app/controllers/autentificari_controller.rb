class AutentificariController < ApplicationController
  # Sare peste autentificarea JWT pentru acest controller (login trebuie sa fie public)
  skip_before_action :autentificare_utilizator

  # Metoda pentru autentificare (login)
  def create
    # Extrage email si parola din obiectul 'autentificari' daca exista, altfel direct din params
    email = params[:autentificari] ? params[:autentificari][:email] : params[:email]
    parola = params[:autentificari] ? params[:autentificari][:parola] : params[:parola]

    # Cauta utilizatorul dupa email si incarca si relatia cu rolul
    utilizator = Utilizator.includes(:rol).find_by(email: email)

    # Verifica daca utilizatorul exista si parola este corecta
    if utilizator && utilizator.authenticate(parola)
      # Creeaza un token JWT care contine ID-ul utilizatorului si ID-ul rolului
      token = JwtService.encode({ utilizator_id: utilizator.id, rol_id: utilizator.rol_id })

      # Returneaza tokenul JWT si informatii despre utilizator, inclusiv numele rolului
      render json: {
        token: token,
        utilizator: {
          id: utilizator.id,
          email: utilizator.email,
          rol_id: utilizator.rol_id,
          rol_nume: utilizator.rol.nume # cheia folosita in frontend pentru redirect
        }
      }, status: :ok
    else
      # Daca autentificarea esueaza, returneaza mesaj de eroare
      render json: { error: "Email sau parola invalida" }, status: :unauthorized
    end
  end

  # Metoda de logout simbolica (nu invalideaza JWT-ul, doar trimite mesaj)
  def destroy
    render json: { mesaj: "Utilizator delogat cu succes" }, status: :ok
  end
end
