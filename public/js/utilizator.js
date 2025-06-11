document.addEventListener("DOMContentLoaded", async () => {
  const token = localStorage.getItem("token");
  if (!token) return window.location.href = "/login.html";

  const headers = { Authorization: "Bearer " + token };

  // Logout
  const logoutBtn = document.getElementById("logout-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", () => {
      localStorage.removeItem("token");
      window.location.href = "login.html";
    });
  }

  // Nume utilizator
  try {
   const resProfil = await fetch("/api/profil_utilizator", { headers });

    const user = await resProfil.json();
    document.getElementById("nume-utilizator").innerText = `${user.nume} ${user.prenume}`;
  } catch (err) {
    alert("Eroare la autentificare.");
    return window.location.href = "/login.html";
  }

  // Programări
  const listaProgramari = document.getElementById("lista-programari");
  try {
    const res = await fetch("/api/programari", { headers });
    if (!res.ok) throw new Error("Eroare server");

    const programari = await res.json();

    if (!programari.length) {
      listaProgramari.innerText = "Nu ai programări active.";
    } else {
      listaProgramari.innerHTML = "";

      programari.forEach(p => {
        console.log("Programare:", p);  // Verificare structura

        const item = document.createElement("div");
        item.className = "list-group-item d-flex justify-content-between align-items-center";

        const text = document.createElement("div");
        text.innerHTML = `<strong>${p.data_programare}</strong> cu Dr. ${p.nume_medic}  Status: ${p.status}`;

        const btn = document.createElement("button");
        btn.className = "btn btn-sm btn-outline-primary";
        btn.textContent = "Detalii";
        btn.addEventListener("click", () => {
          window.location.href = `programare.html?id=${p.id}`;
        });

        item.appendChild(text);
        item.appendChild(btn);
        listaProgramari.appendChild(item);
      });
    }
  } catch (err) {
    listaProgramari.innerText = "Eroare la incarcarea programarilor.";
    console.error(err);
  }

  // Consultații
  const listaConsultatii = document.getElementById("lista-consultatii");
  try {
    const res = await fetch("/api/consultatii", { headers });
    if (!res.ok) throw new Error("Eroare server");

    const consultatii = await res.json();

    if (!consultatii.length) {
      listaConsultatii.innerText = "Nu ai consultații.";
    } else {
      listaConsultatii.innerHTML = "";

      consultatii.forEach(c => {
        const item = document.createElement("div");
        item.className = "list-group-item";
        item.innerHTML = `
           <strong>${c.data}</strong>  cu Dr. ${c.nume_medic || c.nume_pacient || "necunoscut"}
          <button class="btn btn-sm btn-outline-primary float-end ms-2">Detalii</button>
        `;
        listaConsultatii.appendChild(item);
      });
    }
  } catch (err) {
    listaConsultatii.innerText = "Eroare la încărcarea consultațiilor.";
    console.error(err);
  }
});
