--
-- Création de la base de donnée uniquement
-- Les tables sont crées directement depuis django avec les modèles
-- Éxecuter ./manage.py makemigrations && ./manage.py migrate
--

CREATE DATABASE hoop;

-- Création d'un utilisateur Kegtux et application des privilèges
CREATE USER 'hoop'@'localhost' IDENTIFIED BY 'PASSWORD';
GRANT ALL PIVILEGES ON hoop.* TO 'hoop'@'localhost';
FLUSH PRIVILEGES;
