document.addEventListener("DOMContentLoaded", async () => {
  const token = localStorage.getItem("token");
  if (!token) return window.location.href = "/login.html";

  const headers = { Authorization: "Bearer " + token };
  const params = new URLSearchParams(window.location.search);
  const userId = params.get("id");

  let currentUser = null;
  try {
    // 1. Aflăm utilizatorul logat
    const resCurrent = await fetch("/api/current_user", { headers });
    currentUser = await resCurrent.json();
  } catch (err) {
    alert("Eroare autentificare.");
    return window.location.href = "/login.html";
  }

  // 2. Determinăm dacă e profilul propriu
  const isOwner = !userId || userId == currentUser.id;
  const url = isOwner ? "/api/current_user" : `/api/utilizator/${userId}`;

  try {
    const res = await fetch(url, { headers });
    const data = await res.json();

    document.getElementById("nume").innerText = data.nume;
    document.getElementById("prenume").innerText = data.prenume;
    document.getElementById("email").innerText = data.email;
    document.getElementById("rol").innerText = data.rol;
    document.getElementById("nastere").innerText = data.data_nasterii;
   

    //  3. Dacă nu e profilul propriu, ascundem opțiunile
    if (!isOwner) {
      const btnSetari = document.getElementById("btn-setari");
      const btnInapoi = document.getElementById("btn-inapoi");

      if (btnSetari) btnSetari.style.display = "none";
      if (btnInapoi) btnInapoi.style.display = "none";
    }

  } catch (err) {
    document.getElementById("info-utilizator").innerText = "Eroare la încărcarea profilului.";
  }
});
