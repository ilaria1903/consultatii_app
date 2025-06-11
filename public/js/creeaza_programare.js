document.addEventListener("DOMContentLoaded", async () => {
  // Selectăm toate elementele relevante din DOM
  const specializareSelect = document.getElementById("specializare");
  const medicSelect = document.getElementById("medic");
  const lunaSelect = document.getElementById("luna");
  const ziSelect = document.getElementById("zi");
  const oraSelect = document.getElementById("ora");
  const creareBtn = document.getElementById("creare-btn");

  // Dacă avem un formular, împiedicăm trimiterea implicită
  const form = document.querySelector("form");
  if (form) {
    form.addEventListener("submit", e => e.preventDefault());
  }

  // Verificăm dacă utilizatorul este autentificat
  const token = localStorage.getItem("token");
  if (!token) {
    alert("Trebuie să fii autentificat pentru a crea o programare.");
    return;
  }

  // === Încarcă specializările din backend ===
  const specializariRes = await fetch("/specializari", {
    headers: { "Authorization": `Bearer ${token}` }
  });
  if (!specializariRes.ok) return alert("Eroare la încărcarea specializărilor");

  const specializari = await specializariRes.json();
  specializari.forEach(s => {
    const opt = document.createElement("option");
    opt.value = s.id;
    opt.textContent = s.nume;
    specializareSelect.appendChild(opt);
  });

  // === Când selectăm o specializare, încărcăm medicii corespunzători ===
  specializareSelect.addEventListener("change", async () => {
    // Resetăm câmpurile de medic, zi, oră
    medicSelect.innerHTML = "<option value=''>Alege medic</option>";
    ziSelect.innerHTML = "";
    oraSelect.innerHTML = "";

    const res = await fetch(`/medici_din_specializare/${specializareSelect.value}`, {
      headers: { "Authorization": `Bearer ${token}` }
    });

    if (!res.ok) return alert("Eroare la încărcarea medicilor");

    const medici = await res.json();
    medici.forEach(m => {
      const opt = document.createElement("option");
      opt.value = m.id;
      opt.textContent = `${m.nume} ${m.prenume}`;
      medicSelect.appendChild(opt);
    });
  });

  // === Când selectăm un alt medic, resetăm câmpurile de zi și oră ===
  medicSelect.addEventListener("change", () => {
    lunaSelect.value = "";
    ziSelect.innerHTML = "";
    oraSelect.innerHTML = "";
  });

  // === Când alegem luna, încărcăm zilele disponibile ale medicului în acea lună ===
  lunaSelect.addEventListener("change", async () => {
    ziSelect.innerHTML = "<option>Alege zi</option>";
    oraSelect.innerHTML = "";

    const medicId = medicSelect.value;
    const luna = lunaSelect.value;

    if (!medicId || luna === "") return;

    const res = await fetch(`/medici/${medicId}/zile_disponibile?luna=${luna}`, {
      headers: { "Authorization": `Bearer ${token}` }
    });

    if (!res.ok) return alert("Eroare la încărcarea zilelor disponibile");

    const zile = await res.json();
    zile.forEach(z => {
      const opt = document.createElement("option");
      opt.value = z;
      opt.textContent = `Ziua ${z}`;
      ziSelect.appendChild(opt);
    });
  });

  // === Când selectăm ziua, încărcăm orele disponibile pentru acea zi ===
  ziSelect.addEventListener("change", async () => {
    oraSelect.innerHTML = "<option>Alege oră</option>";

    const medicId = medicSelect.value;
    const zi = ziSelect.value;
    const luna = lunaSelect.value;

    if (!medicId || !zi || luna === "") return;

    const an = new Date().getFullYear();
    const ziFormatata = zi.padStart(2, '0');
    const lunaFormatata = (parseInt(luna) + 1).toString().padStart(2, '0');
    const dataComplet = `${an}-${lunaFormatata}-${ziFormatata}`;

    const res = await fetch(`/api/medici/${medicId}/ore_disponibile?zi=${dataComplet}`, {
      headers: { "Authorization": `Bearer ${token}` }
    });

    if (!res.ok) return alert("Eroare la încărcarea orelor disponibile");

    const rezultat = await res.json();
    const ore = rezultat.ore;

    ore.forEach(o => {
      const opt = document.createElement("option");
      opt.value = o;
      opt.textContent = o;
      oraSelect.appendChild(opt);
    });
  });

  // === Când apăsăm pe Confirmă programarea, trimitem cererea POST către backend ===
  creareBtn.addEventListener("click", async () => {
    const medicId = medicSelect.value;
    const zi = ziSelect.value;
    const luna = lunaSelect.value;
    const ora = oraSelect.value;

    // Validare completare câmpuri
    if (!medicId || !zi || luna === "" || !ora) {
      return alert("Completează toate câmpurile!");
    }

    // Construim data programării
    const dataProgramare = new Date();
    dataProgramare.setFullYear(new Date().getFullYear());
    dataProgramare.setMonth(parseInt(luna));
    dataProgramare.setDate(parseInt(zi));
    dataProgramare.setHours(0, 0, 0, 0);

    // Pregătim payload-ul JSON
    const body = {
      medic_id: medicId,
      data_programare: dataProgramare.toISOString().split("T")[0],
      ora_programare: ora + ":00",
      motiv: "Consult general"
    };

    console.log("Trimitem JSON:", JSON.stringify({ programare: body }));

    // Trimitem requestul POST către controllerul ProgramariController#create
    const res = await fetch("/programari", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ programare: body })
    });

    // Verificare răspuns
    if (res.ok) {
      alert("Programare creată cu succes!");
      window.location.href = "/utilizator";
    } else {
      const err = await res.json();
      alert("Eroare: " + (err.eroare || "Nu s-a putut crea programarea"));
    }
  });
});
