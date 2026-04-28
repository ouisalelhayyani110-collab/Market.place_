CREATE DATABASE IF NOT EXISTS curalab USE curalab;

/* 1. SPECIALIZZAZIONI
 Aree mediche del poliambulatorio (usate anche per raggruppare i servizi e come campo di ricerca dei medici) */
CREATE TABLE specializzazioni (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_spec_nome (nome)
);

INSERT INTO
    specializzazioni (nome, descrizione)
VALUES
    (
        'Cardiologia',
        'Diagnosi e cura delle malattie del cuore e del sistema cardiovascolare'
    ),
    (
        'Ginecologia',
        'Salute e prevenzione dell\'apparato riproduttivo femminile'
    ),
    (
        'Ortopedia',
        'Diagnosi e trattamento di ossa, muscoli, articolazioni e tendini'
    ),
    (
        'Ostetricia',
        'Assistenza medica in gravidanza, parto e puerperio'
    ),
    (
        'Dermatologia',
        'Diagnosi e cura delle malattie della pelle, capelli e unghie'
    ),
    (
        'Neurologia',
        'Diagnosi e cura delle malattie del sistema nervoso'
    ),
    (
        'Pediatria',
        'Salute, crescita e sviluppo di neonati e bambini'
    );

/*  2. SERVIZI
 Prestazioni specifiche erogate dal poliambulatorio, raggruppate per specializzazione */
CREATE TABLE servizi (
    id INT NOT NULL AUTO_INCREMENT,
    specializzazione_id INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    durata_default_min INT DEFAULT 30,
    PRIMARY KEY (id),
    CONSTRAINT fk_serv_spec FOREIGN KEY (specializzazione_id) REFERENCES specializzazioni(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

/* on update cascade: se l'id di una specializzazione cambia, aggiorna automaticamente specializzazione_id in tutti i servizi collegati
 on delete restrict: se elimino una specializzazione, non posso eliminare i servizi associati (mysql blocca tutto dando errore) */
INSERT INTO
    servizi (specializzazione_id, nome, durata_default_min)
VALUES
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
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    indirizzo VARCHAR(255) NOT NULL,
    citta VARCHAR(100) NOT NULL,
    cap CHAR(5),
    telefono VARCHAR(20),
    email VARCHAR(150),
    PRIMARY KEY (id)
);

INSERT INTO
    sedi (nome, indirizzo, citta, cap, telefono, email)
VALUES
    (
        'CuraLab – Sede Principale',
        'Via della Salute 1',
        'Torino',
        '10140',
        '011 123456',
        'info@curalab.it'
    ),
    (
        'CuraLab – Sede Centro',
        'Corso Vittorio Emanuele 34',
        'Torino',
        '10123',
        '011 234567',
        'centro@curalab.it'
    ),
    (
        'CuraLab – Sede Mirafiori',
        'Via Giordano Bruno 12',
        'Torino',
        '10137',
        '011 345678',
        'mirafiori@curalab.it'
    ),
    (
        'CuraLab – Sede Moncalieri',
        'Via Roma 88',
        'Moncalieri',
        '10024',
        '011 456789',
        'moncalieri@curalab.it'
    ),
    (
        'CuraLab – Sede Collegno',
        'Corso Francia 200',
        'Collegno',
        '10093',
        '011 567890',
        'collegno@curalab.it'
    );

-- 4. MEDICI
CREATE TABLE medici (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    specializzazione_id INT NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(20),
    foto VARCHAR(255),
    biografia TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_med_spec FOREIGN KEY (specializzazione_id) REFERENCES specializzazioni(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO
    medici (
        nome,
        cognome,
        specializzazione_id,
        email,
        telefono,
        foto,
        biografia
    )
VALUES
    -- Cardiologia (id 1)
    (
        'Marco',
        'Ferretti',
        1,
        'm.ferretti@curalab.it',
        '011 111001',
        NULL,
        'Cardiologo con 15 anni di esperienza in cardiologia interventistica e prevenzione cardiovascolare.'
    ),
    (
        'Laura',
        'Bruno',
        1,
        'l.bruno@curalab.it',
        '011 111002',
        NULL,
        'Specializzata in ecocardiografia e scompenso cardiaco, già primario presso l Ospedale Molinette.'
    ),
    -- Ginecologia (id 2)
    (
        'Alessia',
        'Conti',
        2,
        'a.conti@curalab.it',
        '011 111003',
        NULL,
        'Ginecologa con esperienza in ginecologia oncologica e medicina della riproduzione.'
    ),
    (
        'Giovanna',
        'Marino',
        2,
        'g.marino@curalab.it',
        '011 111004',
        NULL,
        'Specializzata in ecografia ostetrica e diagnosi prenatale con oltre 10 anni di attività clinica.'
    ),
    -- Ortopedia (id 3)
    (
        'Roberto',
        'Esposito',
        3,
        'r.esposito@curalab.it',
        '011 111005',
        NULL,
        'Ortopedico specializzato in patologie del ginocchio e della spalla, esperto in medicina dello sport.'
    ),
    (
        'Stefano',
        'Gallo',
        3,
        's.gallo@curalab.it',
        '011 111006',
        NULL,
        'Ortopedico con esperienza in protesica d anca e chirurgia artroscopica.'
    ),
    -- Ostetricia (id 4)
    (
        'Francesca',
        'Ricci',
        4,
        'f.ricci@curalab.it',
        '011 111007',
        NULL,
        'Ostetrica con esperienza in assistenza alla gravidanza fisiologica e preparazione al parto.'
    ),
    (
        'Chiara',
        'Lombardi',
        4,
        'c.lombardi@curalab.it',
        '011 111008',
        NULL,
        'Specializzata nel supporto alla maternità e nei corsi pre e post parto.'
    ),
    -- Dermatologia (id 5)
    (
        'Andrea',
        'Fontana',
        5,
        'a.fontana@curalab.it',
        '011 111009',
        NULL,
        'Dermatologo esperto in dermatologia estetica, mappatura nei e trattamento dell acne.'
    ),
    (
        'Silvia',
        'Moretti',
        5,
        's.moretti@curalab.it',
        '011 111010',
        NULL,
        'Specializzata in dermatologia pediatrica e malattie autoimmuni della pelle.'
    ),
    -- Neurologia (id 6)
    (
        'Paolo',
        'De Luca',
        6,
        'p.deluca@curalab.it',
        '011 111011',
        NULL,
        'Neurologo con esperienza in cefalee, epilessia e malattie neurodegenerative.'
    ),
    (
        'Elena',
        'Barbieri',
        6,
        'e.barbieri@curalab.it',
        '011 111012',
        NULL,
        'Specializzata in neurologia dello sviluppo e disturbi del sonno.'
    ),
    -- Pediatria (id 7)
    (
        'Giuseppe',
        'Ferrara',
        7,
        'g.ferrara@curalab.it',
        '011 111013',
        NULL,
        'Pediatra con esperienza in neonatologia e sviluppo psicomotorio del bambino.'
    ),
    (
        'Maria',
        'Costa',
        7,
        'm.costa@curalab.it',
        '011 111014',
        NULL,
        'Pediatra specializzata in allergologia pediatrica e nutrizione infantile.'
    );

-- per la foto c'è NULL per tutti: da riempire eventualmente con il percorso di immagini (se vogliamo tenere anche la foto dei medici)

/* 5. MEDICO_SEDE  (N:M)
 Un medico può operare in più sedi; una sede ospita più medici */

CREATE TABLE medico_sede (
    medico_id INT NOT NULL,
    sede_id INT NOT NULL,
    PRIMARY KEY (medico_id, sede_id),
    CONSTRAINT fk_medsede_medico FOREIGN KEY (medico_id) REFERENCES medici(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_medsede_sede FOREIGN KEY (sede_id) REFERENCES sedi(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO
    medico_sede (medico_id, sede_id)
VALUES
    -- Marco Ferretti (cardiologo): Sede Principale + Centro
    (1, 1),
    (1, 2),
    -- Laura Bruno (cardiologa): Sede Mirafiori + Moncalieri
    (2, 3),
    (2, 4),
    -- Alessia Conti (ginecologa): Sede Principale + Collegno
    (3, 1),
    (3, 5),
    -- Giovanna Marino (ginecologa): Sede Centro + Moncalieri
    (4, 2),
    (4, 4),
    -- Roberto Esposito (ortopedico): Sede Principale + Mirafiori
    (5, 1),
    (5, 3),
    -- Stefano Gallo (ortopedico): Sede Centro + Collegno
    (6, 2),
    (6, 5),
    -- Francesca Ricci (ostetrica): Sede Principale
    (7, 1),
    -- Chiara Lombardi (ostetrica): Sede Moncalieri + Collegno
    (8, 4),
    (8, 5),
    -- Andrea Fontana (dermatologo): Sede Principale + Centro
    (9, 1),
    (9, 2),
    -- Silvia Moretti (dermatologa): Sede Mirafiori
    (10, 3),
    -- Paolo De Luca (neurologo): Sede Principale + Moncalieri
    (11, 1),
    (11, 4),
    -- Elena Barbieri (neurologa): Sede Centro + Collegno
    (12, 2),
    (12, 5),
    -- Giuseppe Ferrara (pediatra): Sede Principale + Mirafiori
    (13, 1),
    (13, 3),
    -- Maria Costa (pediatra): Sede Centro + Collegno
    (14, 2),
    (14, 5);

/* 6. MEDICO_SERVIZIO  (N:M)
 Un medico può erogare più servizi; un servizio può essere offerto da più medici
 */
CREATE TABLE medico_servizio (
    medico_id INT NOT NULL,
    servizio_id INT NOT NULL,
    PRIMARY KEY (medico_id, servizio_id),
    CONSTRAINT fk_medserv_medico FOREIGN KEY (medico_id) REFERENCES medici(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_medserv_servizio FOREIGN KEY (servizio_id) REFERENCES servizi(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO
    medico_servizio (medico_id, servizio_id)
VALUES
    -- Marco Ferretti (cardiologo): tutti e tre i servizi cardiologici
    (1, 1),
    (1, 2),
    (1, 3),
    -- Laura Bruno (cardiologa): specializzata in ecocardiografia, fa tutti ma eccelle nel 3
    (2, 1),
    (2, 2),
    (2, 3),
    -- Alessia Conti (ginecologa): visita + pap test (oncologica)
    (3, 4),
    (3, 5),
    -- Giovanna Marino (ginecologa): visita + ecografia ostetrica (prenatale)
    (4, 4),
    (4, 6),
    -- Roberto Esposito (ortopedico): tutti e due i servizi ortopedici
    (5, 7),
    (5, 8),
    -- Stefano Gallo (ortopedico): tutti e due i servizi ortopedici
    (6, 7),
    (6, 8),
    -- Francesca Ricci (ostetrica): visita ostetrica + corso pre-parto
    (7, 9),
    (7, 10),
    -- Chiara Lombardi (ostetrica): corso pre-parto (specializzata supporto maternità)
    (8, 9),
    (8, 10),
    -- Andrea Fontana (dermatologo): visita + mappatura nei (estetica)
    (9, 11),
    (9, 12),
    -- Silvia Moretti (dermatologa): solo visita dermatologica (pediatrica/autoimmune)
    (10, 11),
    -- Paolo De Luca (neurologo): visita + EEG
    (11, 13),
    (11, 14),
    -- Elena Barbieri (neurologa): visita + EEG (disturbi del sonno)
    (12, 13),
    (12, 14),
    -- Giuseppe Ferrara (pediatra): visita pediatrica + bilancio neonatale
    (13, 15),
    (13, 16),
    -- Maria Costa (pediatra): solo visita pediatrica (allergologia)
    (14, 15);

/* 7. DISPONIBILITA
 Turni ricorrenti settimanali del medico per sede.
 Ogni riga definisce una fascia oraria; gli slot prenotabili si ricavano dividendo la fascia per durata_slot_minuti. */

CREATE TABLE disponibilita (
    id INT NOT NULL AUTO_INCREMENT,
    medico_id INT NOT NULL,
    sede_id INT NOT NULL,
    giorno_settimana TINYINT NOT NULL -- '0=Lunedì … 6=Domenica',
    ora_inizio TIME NOT NULL,
    ora_fine TIME NOT NULL,
    durata_slot_minuti INT NOT NULL DEFAULT 30,
    PRIMARY KEY (id),
    CONSTRAINT fk_disp_medico FOREIGN KEY (medico_id) REFERENCES medici(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_disp_sede FOREIGN KEY (sede_id) REFERENCES sedi(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_disp_orario CHECK (ora_fine > ora_inizio),
    CONSTRAINT chk_giorno CHECK (
        giorno_settimana BETWEEN 0
        AND 5
    )
);

INSERT INTO
    disponibilita (
        medico_id,
        sede_id,
        giorno_settimana,
        ora_inizio,
        ora_fine,
        durata_slot_minuti
    )
VALUES
    -- Marco Ferretti (cardiologo): sedi 1 e 2
    (1, 1, 0, '09:00', '13:00', 30),
    -- Lunedì mattina, Sede Principale
    (1, 1, 2, '14:00', '18:00', 30),
    -- Mercoledì pomeriggio, Sede Principale
    (1, 2, 4, '09:00', '13:00', 30),
    -- Venerdì mattina, Sede Centro;
    -- Laura Bruno (cardiologa): sedi 3 e 4
    (2, 3, 1, '09:00', '13:00', 30),
    -- Martedì mattina, Sede Mirafiori
    (2, 4, 3, '14:00', '18:00', 30),
    -- Giovedì pomeriggio, Sede Moncalieri;
    -- Alessia Conti (ginecologa): sedi 1 e 5
    (3, 1, 1, '09:00', '13:00', 30),
    -- Martedì mattina, Sede Principale
    (3, 1, 4, '14:00', '18:00', 30),
    -- Venerdì pomeriggio, Sede Principale
    (3, 5, 3, '09:00', '13:00', 30),
    -- Giovedì mattina, Sede Collegno;
    -- Giovanna Marino (ginecologa): sedi 2 e 4
    (4, 2, 0, '14:00', '18:00', 30),
    -- Lunedì pomeriggio, Sede Centro
    (4, 4, 2, '09:00', '13:00', 30),
    -- Mercoledì mattina, Sede Moncalieri;
    -- Roberto Esposito (ortopedico): sedi 1 e 3
    (5, 1, 0, '09:00', '13:00', 30),
    -- Lunedì mattina, Sede Principale
    (5, 1, 3, '09:00', '13:00', 30),
    -- Giovedì mattina, Sede Principale
    (5, 3, 5, '09:00', '12:00', 30),
    -- Sabato mattina, Sede Mirafiori;
    -- Stefano Gallo (ortopedico): sedi 2 e 5
    (6, 2, 2, '09:00', '13:00', 30),
    -- Mercoledì mattina, Sede Centro
    (6, 5, 4, '14:00', '18:00', 30),
    -- Venerdì pomeriggio, Sede Collegno;
    -- Francesca Ricci (ostetrica): sede 1
    (7, 1, 1, '09:00', '13:00', 30),
    -- Martedì mattina, Sede Principale
    (7, 1, 4, '09:00', '13:00', 60),
    -- Venerdì mattina, Sede Principale (slot da 60 per corso);
    -- Chiara Lombardi (ostetrica): sedi 4 e 5
    (8, 4, 0, '14:00', '18:00', 30),
    -- Lunedì pomeriggio, Sede Moncalieri
    (8, 5, 3, '09:00', '13:00', 60),
    -- Giovedì mattina, Sede Collegno (slot da 60 per corso);
    -- Andrea Fontana (dermatologo): sedi 1 e 2
    (9, 1, 2, '09:00', '13:00', 30),
    -- Mercoledì mattina, Sede Principale
    (9, 2, 0, '14:00', '18:00', 30),
    -- Lunedì pomeriggio, Sede Centro
    (9, 2, 5, '09:00', '12:00', 30),
    -- Sabato mattina, Sede Centro;
    -- Silvia Moretti (dermatologa): sede 3
    (10, 3, 1, '14:00', '18:00', 30),
    -- Martedì pomeriggio, Sede Mirafiori
    (10, 3, 4, '09:00', '13:00', 30),
    -- Venerdì mattina, Sede Mirafiori;
    -- Paolo De Luca (neurologo): sedi 1 e 4
    (11, 1, 0, '14:00', '18:00', 45),
    -- Lunedì pomeriggio, Sede Principale (slot da 45)
    (11, 4, 3, '09:00', '13:00', 45),
    -- Giovedì mattina, Sede Moncalieri (slot da 45);
    -- Elena Barbieri (neurologa): sedi 2 e 5
    (12, 2, 1, '09:00', '13:00', 45),
    -- Martedì mattina, Sede Centro (slot da 45)
    (12, 5, 4, '14:00', '18:00', 45),
    -- Venerdì pomeriggio, Sede Collegno (slot da 45);
    -- Giuseppe Ferrara (pediatra): sedi 1 e 3
    (13, 1, 2, '14:00', '18:00', 30),
    -- Mercoledì pomeriggio, Sede Principale
    (13, 3, 5, '09:00', '12:00', 30),
    -- Sabato mattina, Sede Mirafiori;
    -- Maria Costa (pediatra): sedi 2 e 5
    (14, 2, 3, '14:00', '18:00', 30),
    -- Giovedì pomeriggio, Sede Centro
    (14, 5, 1, '09:00', '13:00', 30);
    -- Martedì mattina, Sede Collegno

-- 9. PAZIENTI
CREATE TABLE pazienti (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    data_nascita DATE,
    codice_fiscale CHAR(16),
    email_confermata BOOLEAN NOT NULL DEFAULT FALSE,
    consenso_termini BOOLEAN NOT NULL DEFAULT FALSE,
    consenso_privacy BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_paz_email (email),
    UNIQUE KEY uq_paz_cf (codice_fiscale)
);

/* 10. TOKEN_VERIFICA
 Usati per conferma email e reset password (one-time link)
 */

CREATE TABLE token_verifica (
    id INT NOT NULL AUTO_INCREMENT,
    paziente_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    tipo ENUM('conferma_email', 'reset_password') NOT NULL,
    scadenza TIMESTAMP NOT NULL,
    usato BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_token (token),
    CONSTRAINT fk_tok_paziente FOREIGN KEY (paziente_id) REFERENCES pazienti(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 11. APPUNTAMENTI

CREATE TABLE appuntamenti (
    id INT NOT NULL AUTO_INCREMENT,
    paziente_id INT NOT NULL,
    medico_id INT NOT NULL,
    servizio_id INT NOT NULL,
    sede_id INT NOT NULL,
    data_ora DATETIME NOT NULL,
    durata_minuti INT NOT NULL DEFAULT 30,
    stato ENUM(
        'in_attesa',
        'confermato',
        'annullato',
        'completato'
    ) NOT NULL DEFAULT 'confermato',
    note TEXT -- 'Note libere del paziente alla prenotazione',
    cancellabile_fino DATETIME -- 'Calcolato al momento della prenotazione (data_ora − 24h)',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_app_paziente FOREIGN KEY (paziente_id) REFERENCES pazienti(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_medico FOREIGN KEY (medico_id) REFERENCES medici(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_servizio FOREIGN KEY (servizio_id) REFERENCES servizi(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_app_sede FOREIGN KEY (sede_id) REFERENCES sedi(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

/* 12. RICHIESTE_CONTATTO
 Messaggi inviati dal form "Contatti" paziente_id è NULL se il mittente non è registrato
 */
CREATE TABLE richieste_contatto (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    oggetto VARCHAR(255),
    messaggio TEXT NOT NULL,
    paziente_id INT DEFAULT NULL,
    presa_in_carico BOOLEAN NOT NULL DEFAULT FALSE,
    data_invio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_cont_paziente FOREIGN KEY (paziente_id) REFERENCES pazienti(id) ON DELETE
    SET
        NULL ON UPDATE CASCADE
);

--  INDICI AGGIUNTIVI (per le query più frequenti)

CREATE INDEX idx_app_paziente ON appuntamenti (paziente_id);

CREATE INDEX idx_app_medico ON appuntamenti (medico_id);

CREATE INDEX idx_app_data ON appuntamenti (data_ora);

CREATE INDEX idx_app_stato ON appuntamenti (stato);

CREATE INDEX idx_disp_medico ON disponibilita (medico_id, giorno_settimana);

CREATE INDEX idx_tok_paziente ON token_verifica (paziente_id, tipo);

CREATE INDEX idx_serv_spec ON servizi (specializzazione_id);