-- DevTok MySQL database for phpMyAdmin
-- Import: phpMyAdmin -> Import -> Choose File -> Go
-- Of: phpMyAdmin -> SQL -> plak dit bestand -> Go

CREATE DATABASE IF NOT EXISTS `devtok`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `devtok`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `comments`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(40) DEFAULT NULL,
  `website` VARCHAR(120) DEFAULT NULL,
  `street` VARCHAR(120) DEFAULT NULL,
  `suite` VARCHAR(80) DEFAULT NULL,
  `city` VARCHAR(80) DEFAULT NULL,
  `zipcode` VARCHAR(20) DEFAULT NULL,
  `company` VARCHAR(120) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_username` (`username`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `category` ENUM('PHP','JavaScript','VueJS') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_posts_user_id` (`user_id`),
  KEY `idx_posts_category` (`category`),
  CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `comments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `body` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_comments_post_id` (`post_id`),
  CONSTRAINT `fk_comments_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Wachtwoorden alleen als hash opslaan. Nooit plaintext of hash tonen in de app.
INSERT INTO `users`
  (`id`, `name`, `username`, `email`, `password_hash`, `phone`, `website`, `street`, `suite`, `city`, `zipcode`, `company`)
VALUES
  (1, 'Cristian Popescu', 'cristian', 'cristian@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-12345678', 'cristian.dev', 'Helper Brink 12', 'Lokaal 2.14', 'Groningen', '9711 AA', 'ROC Alfa-college'),
  (2, 'Sara de Vries', 'saradv', 'sara@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-23456789', 'sara.dev', 'Hereweg 45', 'Apt. 8', 'Groningen', '9725 AG', 'Frontend Lab'),
  (3, 'Jamal El Amrani', 'jamal', 'jamal@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-34567890', 'jamal.php', 'Zuiderdiep 9', 'Studio 3', 'Groningen', '9711 JC', 'PHP Crew'),
  (4, 'Lotte Bakker', 'lotte', 'lotte@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-45678901', 'lotte.vue', 'Oosterstraat 21', 'Kamer 4', 'Groningen', '9711 NN', 'Vue Club'),
  (5, 'Noah Jansen', 'noah', 'noah@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-56789012', 'noah.js', 'Grote Markt 1', 'Boven', 'Groningen', '9711 LV', 'JS Guild'),
  (6, 'Amina Hassan', 'amina', 'amina@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-67890123', 'amina.code', 'Westersingel 18', 'Apt. 12', 'Groningen', '9718 CL', 'API Team'),
  (7, 'Daan Visser', 'daan', 'daan@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-78901234', 'daan.sql', 'Peperstraat 7', 'Werkplek 5', 'Groningen', '9711 PH', 'Database Lab'),
  (8, 'Eva Meijer', 'eva', 'eva@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-89012345', 'eva.ui', 'Folkingestraat 3', 'Apt. 2', 'Groningen', '9711 JT', 'UX Studio'),
  (9, 'Timo de Boer', 'timo', 'timo@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-90123456', 'timo.full', 'Gedempte Zuiderdiep 32', 'Lokaal 1.08', 'Groningen', '9711 HG', 'Fullstack Circle'),
  (10, 'Mila van Dijk', 'mila', 'mila@devtok.demo', '$2y$10$wQ0nR3mY8vL6pK1sT9uAOe0kQm3nF8xY2cB5dH7jL9pR1sT3vX4aK', '06-01234567', 'mila.dev', 'Nieuwe Ebbingestraat 50', 'Kamer 9', 'Groningen', '9712 NL', 'DevTok Moderators');

INSERT INTO `posts` (`id`, `user_id`, `title`, `body`, `category`) VALUES
  (1, 3, 'Hoe verbind ik PHP met MySQL in XAMPP?', 'Ik wil DevTok lokaal laten werken met phpMyAdmin. Welke stappen moet ik zetten voor mysqli of PDO, en waar zet ik de databasegegevens veilig neer zonder ze in JavaScript te zetten?', 'PHP'),
  (2, 5, 'fetch() geeft CORS-fout bij mijn API', 'Mijn feed haalt posts op via fetch, maar de browser blokkeert het request. Hoe zet ik Access-Control-Allow-Origin goed in PHP zodat Live Server op poort 5501 mag praten met localhost/api?', 'JavaScript'),
  (3, 4, 'VueJS component of gewoon HTML?', 'Voor module 14 moet ik VueJS leren. Kan ik DevTok later omzetten naar Vue-componenten voor de feed, categorieën en de detailpagina zonder de API te wijzigen?', 'VueJS'),
  (4, 1, 'PDO prepared statements: wanneer verplicht?', 'Ik zie overal dat je geen SQL mag plakken met variabelen. Hoe schrijf ik een veilige SELECT voor posts op id en een INSERT voor comments in PHP?', 'PHP'),
  (5, 2, 'Tekst afkappen op één regel in CSS', 'Op de startpagina moet de posttekst maar één regel zijn. Is text-overflow ellipsis genoeg, of moet ik de body in JavaScript afkappen?', 'JavaScript'),
  (6, 4, 'Pinia of gewoon reactive state?', 'Ik wil later likes en de gekozen categorie in Vue bijhouden. Is Pinia nodig voor deze opdracht, of is een simpele ref in App.vue genoeg?', 'VueJS'),
  (7, 7, 'Relaties tussen users, posts en comments', 'Hoe teken ik het ERD? Een user heeft veel posts, een post heeft veel comments. Moet comment ook een user_id hebben of alleen name en email zoals JSONPlaceholder?', 'PHP'),
  (8, 5, 'async/await versus Promise.all', 'In app.js haal ik posts en users tegelijk op. Is Promise.all sneller, en wat gebeurt er als één van de twee fetch-calls faalt?', 'JavaScript'),
  (9, 8, 'Vue router voor detailpagina', 'Kan ik /post/:id maken in Vue Router zodat ik geen detail.html meer nodig heb, en de comments-sectie via een hash of query openen?', 'VueJS'),
  (10, 6, 'JSON teruggeven vanuit PHP', 'Mijn API echo''t HTML in plaats van JSON. Moet ik header Content-Type application/json zetten en json_encode gebruiken?', 'PHP'),
  (11, 9, 'Escape HTML in de feed', 'Als iemand <script> in een titel zet, kan dat gevaarlijk zijn. Waarom escapeHtml in JavaScript, als de API ook htmlspecialchars kan doen?', 'JavaScript'),
  (12, 4, 'v-for en keys in een feed', 'Als ik posts render met v-for, welke key gebruik ik dan? Id van de post, of de index? En hoe filter ik op categorie zonder de API opnieuw te vragen?', 'VueJS'),
  (13, 3, 'Wachtwoorden nooit in een user-overzicht', 'Voor de users-pagina: welke kolommen mag ik tonen? Name, username, city, company. Password_hash blijft in de database en gaat niet naar de frontend.', 'PHP'),
  (14, 2, 'Live Server en PHP tegelijk draaien', 'Live Server is poort 5501 en Apache is 80. Mag JavaScript naar http://localhost/devtok/api/posts.php fetchen, of moet alles onder htdocs staan?', 'JavaScript'),
  (15, 10, 'Computed properties voor zoeken', 'Ik wil in Vue zoeken op titel en body. Is een computed property beter dan de input-event in vanilla JS, en hoe reset ik de lijst bij een lege query?', 'VueJS'),
  (16, 7, 'AUTO_INCREMENT en POST comments', 'JSONPlaceholder geeft een fake id 501 terug. In MySQL moet INSERT INTO comments een echte nieuwe id geven. Hoe lees ik lastInsertId in PDO?', 'PHP'),
  (17, 5, 'Detailpagina vullen met querystring id', 'Ik open detail.html?id=3. Hoe haal ik die id betrouwbaar uit URLSearchParams, en wat toon ik als id ontbreekt of de post niet bestaat?', 'JavaScript'),
  (18, 8, 'Formulier voor nieuwe reactie in Vue', 'Moet ik v-model gebruiken voor naam en tekst, @submit.prevent, en daarna een POST naar de API? Hoe toon ik een foutmelding als de server 500 teruggeeft?', 'VueJS'),
  (19, 1, 'Categorie als ENUM of aparte tabel?', 'In DevTok gebruik ik PHP, JavaScript en VueJS. Is ENUM in MySQL prima voor school, of is een categories-tabel netter als er later meer tags bijkomen?', 'PHP'),
  (20, 6, '404 als de post niet bestaat', 'De API moet 404 JSON geven als /posts/99 niet bestaat, niet een lege 200. Hoe check ik rowCount in PHP voordat ik json_encode doe?', 'JavaScript');

INSERT INTO `comments` (`id`, `post_id`, `name`, `email`, `body`) VALUES
  (1, 1, 'Sara de Vries', 'sara@devtok.demo', 'Zet de databasegegevens in een PHP-configbestand buiten de public js-map. JavaScript mag nooit het MySQL-wachtwoord zien.'),
  (2, 1, 'Daan Visser', 'daan@devtok.demo', 'In phpMyAdmin: nieuwe database devtok, daarna dit SQL-bestand importeren. Test daarna met een kleine SELECT in het SQL-tabblad.'),
  (3, 2, 'Amina Hassan', 'amina@devtok.demo', 'Voeg in PHP header Access-Control-Allow-Origin toe, en bij POST ook Access-Control-Allow-Headers voor Content-Type.'),
  (4, 3, 'Timo de Boer', 'timo@devtok.demo', 'Begin met de huidige HTML/JS. Als de API stabiel is, kun je de feed 1-op-1 naar Vue-componenten tillen.'),
  (5, 4, 'Jamal El Amrani', 'jamal@devtok.demo', 'Gebruik PDO met named placeholders: SELECT * FROM posts WHERE id = :id. Bind de waarde, execute, fetch.'),
  (6, 5, 'Eva Meijer', 'eva@devtok.demo', 'white-space:nowrap; overflow:hidden; text-overflow:ellipsis; op .description is precies wat de opdracht vraagt.'),
  (7, 7, 'Mila van Dijk', 'mila@devtok.demo', 'Voor school mag comments.name en comments.email, net als JSONPlaceholder. Later kun je user_id toevoegen als mensen inloggen.'),
  (8, 10, 'Cristian Popescu', 'cristian@devtok.demo', 'Eerst header Content-Type: application/json, daarna echo json_encode($data). Geen HTML ervoor echoën.'),
  (9, 13, 'Lotte Bakker', 'lotte@devtok.demo', 'Op de users-lijst alleen naam, username en stad. Op user-detail mag meer, maar nooit password_hash.'),
  (10, 16, 'Noah Jansen', 'noah@devtok.demo', 'Na execute() is $pdo->lastInsertId() de nieuwe comment-id. Stuur die terug in de JSON-response.');

ALTER TABLE `users` AUTO_INCREMENT = 11;
ALTER TABLE `posts` AUTO_INCREMENT = 21;
ALTER TABLE `comments` AUTO_INCREMENT = 11;
