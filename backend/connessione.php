<?php
// Include l'autoloader di Composer (fondamentale per caricare le librerie)
require_once __DIR__ . '/vendor/autoload.php';

// Inizializza Dotenv
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Recupera i dati dal file .env usando $_ENV
$host = $_ENV['DB_HOST'];
$db   = $_ENV['DB_NAME'];
$user = $_ENV['DB_USER'];
$pass = $_ENV['DB_PASS'];

try {
    // Crea la connessione con PDO
    $connessione = new PDO("mysql:host=$host;dbname=$db;charset=utf8", $user, $pass);
    
    // Imposta l'estensione per gestire gli errori
    $connessione->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "Connessione sicura al database riuscita!";
} catch (PDOException $e) {
    echo "Errore di connessione: " . $e->getMessage();
}



