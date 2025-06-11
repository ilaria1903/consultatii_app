// Asteapta ca intreaga pagina HTML sa fie incarcata
document.addEventListener("DOMContentLoaded", function () {
  // Preia elementele din DOM
  const form = document.getElementById("login-form");
  const emailInput = document.getElementById("email");
  const parolaInput = document.getElementById("parola");
  const mesajEl = document.getElementById("rezultat-login");

  // Verifica daca formularul exista in pagina
  if (!form) {
    console.error("login-form nu exista in pagina.");
    return;
  }

  // Ataseaza un eveniment la trimiterea formularului
  form.addEventListener("submit", function (e) {
    e.preventDefault(); // Opreste comportamentul standard (refresh)

    // Reseteaza mesajul afisat
    mesajEl.innerText = '';
    mesajEl.style.color = 'red';

    // Verifica daca toate campurile sunt completate
    if (!emailInput.value || !parolaInput.value) {
      mesajEl.innerText = "Completeaza toate campurile!";
      return;
    }

    // Trimite o cerere POST catre backend pentru autentificare
    fetch("/autentificari", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        autentificari: {
          email: emailInput.value,
          parola: parolaInput.value
        }
      })
    })
      // Transforma raspunsul in obiect JS
      .then(res => res.json())
      .then(data => {
        console.log(" Raspuns primit de la backend:", data);

        // Incearca sa extraga tokenul JWT
        const token = data.token || data.jwt || data.access_token;

        if (token) {
          // Salveaza tokenul in localStorage pentru utilizari ulterioare
          localStorage.setItem("token", token);

          // Verifica rolul utilizatorului pentru redirectionare
          const rol = data.utilizator?.rol_nume;

          if (rol === "pacient") {
            window.location.href = "/utilizator.html"; // dashboard pacient
          } else if (rol === "medic") {
            window.location.href = "/utilizator_medic"; // dashboard medic (servit de backend)
          } else {
            mesajEl.innerText = "Rol necunoscut. Contacteaza administratorul.";
          }

        } else {
          // Daca nu s-a primit token, afiseaza eroare
          mesajEl.innerText = "Autentificare esuata: token lipsa in raspuns";
        }
      })
      .catch(err => {
        // Daca cererea fetch esueaza (server nefunctional, retea etc.)
        console.error("Eroare fetch:", err);
        mesajEl.innerText = "Eroare la conectare.";
      });
  });
});
