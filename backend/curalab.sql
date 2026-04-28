CREATE DATABASE IF NOT EXISTS curalab

USE curalab;

/* 1. SPECIALIZZAZIONI
Aree mediche del poliambulatorio (usate anche per raggruppare i servizi e come campo di ricerca dei medici) */

CREATE TABLE specializzazioni (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_spec_nome (nome)
);

INSERT INTO specializzazioni (nome, descrizione) VALUES
    ('Cardiologia', 'Diagnosi e cura delle malattie del cuore e del sistema cardiovascolare'),
    ('Ginecologia', 'Salute e prevenzione dell\'apparato riproduttivo femminile'),
    ('Ortopedia', 'Diagnosi e trattamento di ossa, muscoli, articolazioni e tendini'),
    ('Ostetricia', 'Assistenza medica in gravidanza, parto e puerperio'),
    ('Dermatologia', 'Diagnosi e cura delle malattie della pelle, capelli e unghie'),
    ('Neurologia', 'Diagnosi e cura delle malattie del sistema nervoso'),
    ('Pediatria', 'Salute, crescita e sviluppo di neonati e bambini');

/*  2. SERVIZI
Prestazioni specifiche erogate dal poliambulatorio, raggruppate per specializzazione */

CREATE TABLE servizi (
    id INT NOT NULL AUTO_INCREMENT,
    specializzazione_id INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descrizione TEXT,                               
    durata_default_min INT DEFAULT 30, 
    PRIMARY KEY (id),
    CONSTRAINT fk_serv_spec FOREIGN KEY (specializzazione_id)
        REFERENCES specializzazioni(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO servizi (specializzazione_id, nome, durata_default_min) VALUES
    (1, 'Visita cardiologica', 30),
    (1, 'Elettrocardiogramma (ECG)', 20),
    (1, 'Ecocardiogramma', 45),
    (2, 'Visita ginecologica', 30),
    (2, 'Pap test e colposcopia', 30),
    (2, 'Ecografia ostetrica', 30),
    (3, 'Visita ortopedica', 30),
    (3, 'Infiltrazione articolare', 30),
    (4, 'Visita ostetrica', 30),
    (4, 'Corso pre-parto', 60),
    (5, 'Visita dermatologica', 30),
    (5, 'Mappatura nei', 30),
    (6, 'Visita neurologica', 45),
    (6, 'Elettroencefalogramma (EEG)', 60),
    (7, 'Visita pediatrica', 30),
    (7, 'Bilancio di salute neonatale', 30);


/* 3. SEDI
Sedi fisiche del poliambulatorio */

CREATE TABLE sedi (
    id        INT          NOT NULL AUTO_INCREMENT,
    nome      VARCHAR(150) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    citta     VARCHAR(100) NOT NULL,
    cap       CHAR(5),
    telefono  VARCHAR(20),
    email     VARCHAR(150),
    attiva    BOOLEAN      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id)
);

INSERT INTO sedi (nome, indirizzo, citta, cap, telefono, email) VALUES
    ('CuraLab – Sede Principale', 'Via della Salute 1', 'Torino', '10140', '011 123456', 'info@curalab.it');


-- 4. MEDICI

CREATE TABLE medici (
    id                  INT          NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(100) NOT NULL,
    cognome             VARCHAR(100) NOT NULL,
    specializzazione_id INT          NOT NULL,  
    email               VARCHAR(150),
    telefono            VARCHAR(20),
    foto                VARCHAR(255),
    biografia           TEXT,                   
    bio_estesa          TEXT,                   
    esperienza          TEXT,                   
    attivo              BOOLEAN      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id),
    CONSTRAINT fk_med_spec FOREIGN KEY (specializzazione_id)
        REFERENCES specializzazioni(id) ON UPDATE CASCADE ON DELETE RESTRICT
);


/* 5. MEDICO_SEDE  (N:M)
Un medico può operare in più sedi; una sede ospita più medici */

CREATE TABLE medico_sede (
    medico_id INT NOT NULL,
    sede_id   INT NOT NULL,
    PRIMARY KEY (medico_id, sede_id),
    CONSTRAINT fk_ms_medico FOREIGN KEY (medico_id)
        REFERENCES medici(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ms_sede   FOREIGN KEY (sede_id)
        REFERENCES sedi(id)   ON DELETE CASCADE ON UPDATE CASCADE
);


/* 6. MEDICO_SERVIZIO  (N:M)
Un medico può erogare più servizi; un servizio può essere offerto da più medici
 */

CREATE TABLE medico_servizio (
    medico_id   INT NOT NULL,
    servizio_id INT NOT NULL,
    PRIMARY KEY (medico_id, servizio_id),
    CONSTRAINT fk_msv_medico   FOREIGN KEY (medico_id)
        REFERENCES medici(id)   ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_msv_servizio FOREIGN KEY (servizio_id)
        REFERENCES servizi(id)  ON DELETE CASCADE ON UPDATE CASCADE
);


/* 7. DISPONIBILITA
Turni ricorrenti settimanali del medico per sede.
Ogni riga definisce una fascia oraria; gli slot prenotabili si ricavano dividendo la fascia per durata_slot_minuti. */

CREATE TABLE disponibilita (
    id                  INT       NOT NULL AUTO_INCREMENT,
    medico_id           INT       NOT NULL,
    sede_id             INT       NOT NULL,
    giorno_settimana    TINYINT   NOT NULL -- '0=Lunedì … 6=Domenica',
    ora_inizio          TIME      NOT NULL,
    ora_fine            TIME      NOT NULL,
    durata_slot_minuti  INT       NOT NULL DEFAULT 30,
    attiva              BOOLEAN   NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id),
    CONSTRAINT fk_disp_medico FOREIGN KEY (medico_id)
        REFERENCES medici(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_disp_sede   FOREIGN KEY (sede_id)
        REFERENCES sedi(id)   ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_disp_orario CHECK (ora_fine > ora_inizio),
    CONSTRAINT chk_giorno      CHECK (giorno_settimana BETWEEN 0 AND 6)
);


-- 9. PAZIENTI

CREATE TABLE pazienti (
    id                  INT          NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(100) NOT NULL,
    cognome             VARCHAR(100) NOT NULL,
    email               VARCHAR(150) NOT NULL,
    password_hash       VARCHAR(255) NOT NULL,
    telefono            VARCHAR(20),
    data_nascita        DATE,
    codice_fiscale      CHAR(16),
    attivo              BOOLEAN      NOT NULL DEFAULT FALSE -- 'FALSE finché email non confermata',
    email_confermata    BOOLEAN      NOT NULL DEFAULT FALSE,
    consenso_termini    BOOLEAN      NOT NULL DEFAULT FALSE,
    consenso_privacy    BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          TIMESTAMP             DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_paz_email (email),
    UNIQUE KEY uq_paz_cf    (codice_fiscale)
);



/* 10. TOKEN_VERIFICA
Usati per conferma email e reset password (one-time link)
 */

CREATE TABLE token_verifica (
    id          INT          NOT NULL AUTO_INCREMENT,
    paziente_id INT          NOT NULL,
    token       VARCHAR(255) NOT NULL,
    tipo        ENUM('conferma_email','reset_password') NOT NULL,
    scadenza    TIMESTAMP    NOT NULL,
    usato       BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_token (token),
    CONSTRAINT fk_tok_paziente FOREIGN KEY (paziente_id)
        REFERENCES pazienti(id) ON DELETE CASCADE ON UPDATE CASCADE
);



-- 11. APPUNTAMENTI

CREATE TABLE appuntamenti (
    id                  INT      NOT NULL AUTO_INCREMENT,
    paziente_id         INT      NOT NULL,
    medico_id           INT      NOT NULL,
    servizio_id         INT      NOT NULL,
    sede_id             INT      NOT NULL,
    data_ora            DATETIME NOT NULL,
    durata_minuti       INT      NOT NULL DEFAULT 30,
    stato               ENUM('in_attesa','confermato','annullato','completato')
                                 NOT NULL DEFAULT 'confermato',
    note                TEXT              -- 'Note libere del paziente alla prenotazione',
    cancellabile_fino   DATETIME          -- 'Calcolato al momento della prenotazione (data_ora − 24h)',
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_app_paziente FOREIGN KEY (paziente_id)
        REFERENCES pazienti(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_medico   FOREIGN KEY (medico_id)
        REFERENCES medici(id)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_servizio FOREIGN KEY (servizio_id)
        REFERENCES servizi(id)  ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_sede     FOREIGN KEY (sede_id)
        REFERENCES sedi(id)     ON DELETE RESTRICT ON UPDATE CASCADE
);



/* 12. RICHIESTE_CONTATTO
Messaggi inviati dal form "Contatti" paziente_id è NULL se il mittente non è registrato
 */
CREATE TABLE richieste_contatto (
    id               INT          NOT NULL AUTO_INCREMENT,
    nome             VARCHAR(150) NOT NULL,
    email            VARCHAR(150) NOT NULL,
    oggetto          VARCHAR(255),
    messaggio        TEXT         NOT NULL,
    paziente_id      INT                   DEFAULT NULL,
    presa_in_carico  BOOLEAN      NOT NULL DEFAULT FALSE,
    data_invio       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_cont_paziente FOREIGN KEY (paziente_id)
        REFERENCES pazienti(id) ON DELETE SET NULL ON UPDATE CASCADE
);



--  INDICI AGGIUNTIVI (per le query più frequenti)

CREATE INDEX idx_app_paziente   ON appuntamenti (paziente_id);
CREATE INDEX idx_app_medico     ON appuntamenti (medico_id);
CREATE INDEX idx_app_data       ON appuntamenti (data_ora);
CREATE INDEX idx_app_stato      ON appuntamenti (stato);
CREATE INDEX idx_disp_medico    ON disponibilita (medico_id, giorno_settimana);
CREATE INDEX idx_tok_paziente   ON token_verifica (paziente_id, tipo);
CREATE INDEX idx_serv_spec      ON servizi (specializzazione_id);
