-- Table structure for table utilizatori
CREATE TABLE utilizatori (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    parola VARCHAR(255) NOT NULL,
    rol_id INTEGER REFERENCES roluri(id),
    creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for table roluri
CREATE TABLE roluri (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(50) UNIQUE NOT NULL CHECK (nume IN ('admin', 'medic', 'pacient'))
);

-- Table structure for table programari
CREATE TABLE programari (
    id SERIAL PRIMARY KEY,
    pacient_id INTEGER REFERENCES utilizatori(id),
    medic_id INTEGER REFERENCES utilizatori(id),
    data_programare DATE NOT NULL,
    ora_programare TIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'aprobata', 'respinsa', 'anulata')),
    motiv TEXT,
    creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(pacient_id, medic_id, data_programare, ora_programare)
);

-- Table structure for table consultatie
CREATE TABLE consultatie (
    id SERIAL PRIMARY KEY,
    programare_id INTEGER UNIQUE REFERENCES programari(id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL CHECK (end_time > start_time),
    durata_minute INTEGER CHECK (durata_minute BETWEEN 1 AND 30)
);

-- Table structure for table chat
CREATE TABLE chat (
    id SERIAL PRIMARY KEY,
    consultatie_id INTEGER UNIQUE REFERENCES consultatie(id) ON DELETE CASCADE,
    started_at TIMESTAMP,
    ended_at TIMESTAMP CHECK (ended_at > started_at)
);

-- Table structure for table mesaj
CREATE TABLE mesaj (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chat(id) ON DELETE CASCADE,
    sender_id INTEGER REFERENCES utilizatori(id) ON DELETE CASCADE,
    content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tip VARCHAR(20) CHECK (tip IN ('text', 'fisier')) NOT NULL
);

-- Table structure for table fisiere
CREATE TABLE fisiere (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chat(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES utilizatori(id) ON DELETE CASCADE,
    file_url TEXT NOT NULL,
    file_type VARCHAR(20) NOT NULL,
    nume_fisier VARCHAR(255) NOT NULL,
    upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for table notificare
CREATE TABLE notificare (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES utilizatori(id),
    titlu TEXT,
    mesaj TEXT,
    creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    citita BOOLEAN DEFAULT FALSE
);

-- Table structure for table plata
CREATE TABLE plata (
    id SERIAL PRIMARY KEY,
    consultatie_id INTEGER REFERENCES consultatie(id) ON DELETE CASCADE,
    suma NUMERIC(10,2) NOT NULL CHECK (suma > 0),
    status VARCHAR(20) CHECK (status IN ('efectuata', 'esuat', 'in_asteptare')) NOT NULL,
    procesator VARCHAR(50),
    data_plata TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for table recenzie
CREATE TABLE recenzie (
    id SERIAL PRIMARY KEY,
    consultatie_id INTEGER UNIQUE REFERENCES consultatie(id) ON DELETE CASCADE,
    stele INTEGER CHECK (stele BETWEEN 1 AND 5),
    rating_creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for table video
CREATE TABLE video (
    id SERIAL PRIMARY KEY,
    consultation_id INTEGER UNIQUE REFERENCES consultatie(id) ON DELETE CASCADE,
    video_url TEXT NOT NULL,
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending', 'active', 'ended', 'failed'))
);

-- Table structure for table specializari
CREATE TABLE specializari (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(100) UNIQUE NOT NULL
);

-- Table structure for table medic_specializari
CREATE TABLE medic_specializari (
    id SERIAL PRIMARY KEY,
    medic_id INTEGER REFERENCES utilizatori(id) ON DELETE CASCADE,
    specializare_id INTEGER REFERENCES specializari(id) ON DELETE CASCADE,
    UNIQUE(medic_id, specializare_id)
);

-- Sample data for roles
INSERT INTO roluri (nume) VALUES ('admin'), ('medic'), ('pacient');

-- Example user entries
INSERT INTO utilizatori (email, parola, rol_id) VALUES
('admin@example.com', 'hashed_password_1', 1),
('medic1@example.com', 'hashed_password_2', 2),
('pacient1@example.com', 'hashed_password_3', 3);

-- Sample specializari
INSERT INTO specializari (nume) VALUES ('Cardiologie'), ('Dermatologie'), ('Neurologie');

-- Medic specializations
INSERT INTO medic_specializari (medic_id, specializare_id) VALUES
(2, 1),
(2, 3);

-- Sample programari
INSERT INTO programari (pacient_id, medic_id, data_programare, ora_programare, status, motiv)
VALUES (3, 2, '2025-06-15', '10:00', 'aprobata', 'Consultatie control');
