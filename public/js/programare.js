// Asteapta ca intreaga pagina sa se incarce inainte de a rula scriptul
document.addEventListener("DOMContentLoaded", async () => {
  // Extrage token-ul JWT din localStorage
  const token = localStorage.getItem("token");

  // Daca nu exista token, redirectioneaza utilizatorul catre pagina de login
  if (!token) return window.location.href = "/login.html";

  // Preia ID-ul programarii din URL (ex: ?id=5)
  const id = new URLSearchParams(window.location.search).get("id");

  // Pregateste headerul cu tokenul pentru autorizare
  const headers = { Authorization: "Bearer " + token };

  // Selecteaza elementele HTML unde se vor afisa detaliile
  const container = document.getElementById("detalii-programare");
  const btnAnuleaza = document.getElementById("btn-anuleaza");

  try {
    // Trimite o cerere GET pentru a obtine detaliile programarii
    const res = await fetch(`/api/programari/${id}`, { headers });

    // Transforma raspunsul JSON in obiect JS
    const p = await res.json();

    // Afiseaza detaliile programarii in pagina
    container.innerHTML = `
      <p><strong>Data:</strong> ${p.data_programare}</p>
      <p><strong>Ora:</strong> ${p.ora_programare}</p>
      <p><strong>Status:</strong> ${p.status}</p>
      <p><strong>Motiv:</strong> ${p.motiv || '—'}</p>
      <p><strong>Creata la:</strong> ${p.created_at}</p>
    `;

    // Daca programarea este deja anulata, dezactiveaza butonul
    if (p.status === 'anulata') {
      btnAnuleaza.disabled = true;
      btnAnuleaza.innerText = "Programarea este deja anulata";
    } else {
      // Altfel, ataseaza un eveniment pentru anulare
      btnAnuleaza.addEventListener("click", async () => {
        // Cere confirmare utilizatorului inainte de anulare
        if (!confirm("Sigur vrei sa anulezi programarea?")) return;

        // Trimite o cerere DELETE pentru a anula programarea
        const resDelete = await fetch(`/programari/${id}`, {
          method: "DELETE",
          headers
        });

        // Daca cererea a reusit, afiseaza mesaj si redirectioneaza
        if (resDelete.ok) {
          alert("Programarea a fost anulata.");
          window.location.href = "/utilizator.html";
        } else {
          alert("Eroare la anulare.");
        }
      });
    }

  } catch (err) {
    // In caz de eroare (de retea, backend, token invalid), afiseaza mesaj
    container.innerText = "Eroare la incarcarea programarii.";
    btnAnuleaza.style.display = "none";
  }
});
