document.addEventListener("DOMContentLoaded", function () {
  const cereriContainer = document.getElementById("cereri-programari");
  const consultatiiContainer = document.getElementById("consultatii-viitoare");
  const logoutBtn = document.getElementById("logout-btn");

  const token = localStorage.getItem("token");

  if (!token) {
    window.location.href = "/login.html";
    return;
  }

  // Logout
  logoutBtn.addEventListener("click", function () {
    localStorage.removeItem("token");
    window.location.href = "/login.html";
  });



  fetch("/api/current_user", {
  headers: { Authorization: `Bearer ${token}` }
})
  .then(res => res.json())
  .then(user => {
  console.log(" Medic logat:", user);
  const spanNume = document.getElementById("nume-medic");
  if (spanNume) {
    spanNume.innerText = `Dr. ${user.nume} ${user.prenume}`;
  }
});

  // Încarcă cererile de programări pending
  fetch("/api/programari", {
    headers: { Authorization: `Bearer ${token}` }
  })
    .then(res => res.json())
    .then(data => {
        console.log("Programări primite:", data);

      const cereri = data.filter(p => p.status === "pending");

      cereri.forEach(programare => {
        const item = document.createElement("div");
        item.classList.add("list-group-item");

        item.innerHTML = `
          <a href="/profil.html?id=${programare.pacient_id}">Accesează profil</a>



          <p><strong>Data:</strong> ${programare.data_programare}</p>
          <p><strong>Ora:</strong> ${programare.ora_programare}</p>
          <p><strong>Motiv:</strong> ${programare.motiv || 'Nespecificat'}</p>
          <button class="btn btn-success me-2" onclick="modificaStatus('${programare.id}', 'aprobata')">Acceptă</button>
          <button class="btn btn-danger" onclick="modificaStatus('${programare.id}', 'respinsa')">Refuză</button>
        `;
        cereriContainer.appendChild(item);
      });
    });

  // Încarcă consultațiile viitoare
  fetch("/api/consultatii", {
    headers: { Authorization: `Bearer ${token}` }
  })
    .then(res => res.json())
    .then(data => {
      data.forEach(consultatie => {
        const item = document.createElement("div");
        item.classList.add("list-group-item");

        const acum = new Date();
        const inceput = new Date(`${consultatie.data}T${consultatie.ora_start}`);

        const activa = inceput <= acum;

        item.innerHTML = `
        <a href="/profil.html?id=${consultatie.pacient_id}">Accesează profil</a>



          <p><strong>Ora:</strong> ${consultatie.ora_start}</p>
          ${activa ? '<button class="btn btn-primary">💬 Deschide consultație</button>' : '<span class="text-muted">Consultație programată</span>'}
        `;
        consultatiiContainer.appendChild(item);
      });
    });
});

// Funcție pentru acceptare/refuzare cerere
function modificaStatus(id, statusNou) {
  const token = localStorage.getItem("token");

  fetch(`/programari/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`
    },
    body: JSON.stringify({ programare: { status: statusNou } })
  })
    .then(res => {
      if (res.ok) {
        alert("Status actualizat!");
        location.reload();
      } else {
        alert("Eroare la actualizare status.");
      }
    });
}
