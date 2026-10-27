# DevTok

DevTok is een TikTok-achtige forumapp voor studenten Software Development.

## Functies

- Verticale TikTok-achtige feed
- Posts ophalen via een eigen PHP-API
- Volledige titel op de startpagina
- Posttekst wordt op één regel afgekapt
- Categorieën: Alle, PHP, JavaScript en VueJS
- Zoeken in posts
- Like-knop
- Bookmark-knop
- Reactieknop
- Detailpagina met volledige post
- Auteur van de post
- Alle comments ophalen via API
- Nieuwe comment opslaan in MySQL
- Responsive ontwerp voor mobiel en desktop

## 1. Database importeren

1. Start Apache en MySQL in XAMPP (of WAMP).
2. Open [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
3. Kies **Importeren**.
4. Kies `database/devtok.sql`.
5. Klik op **Starten**.

Database: `devtok`  
Tabellen: `users`, `posts`, `comments`  
`password_hash` gaat nooit naar de frontend.

## 2. PHP-API in Apache zetten

Kopieer de projectmap naar:

`C:\xampp\htdocs\devtok`

De API staat dan op:

- [http://localhost/devtok/api/posts.php](http://localhost/devtok/api/posts.php)
- [http://localhost/devtok/api/users.php](http://localhost/devtok/api/users.php)
- [http://localhost/devtok/api/comments.php?postId=1](http://localhost/devtok/api/comments.php?postId=1)

Standaard XAMPP-login in `api/config.php`: gebruiker `root`, wachtwoord leeg. Pas dat aan als jouw MySQL een wachtwoord heeft.

## 3. App openen

**Optie A — alles via Apache**

Open [http://localhost/devtok/](http://localhost/devtok/)

**Optie B — Live Server (poort 5501)**

Rechtsklik `index.html` → **Open with Live Server**.  
JavaScript haalt data dan op van `http://localhost/devtok/api`. Apache moet daarvoor draaien.

## API-endpoints

| Methode | URL | Doel |
|---|---|---|
| GET | `api/posts.php` | Alle berichten |
| GET | `api/posts.php?id=1` | Eén bericht |
| GET | `api/users.php` | Alle users (zonder wachtwoord) |
| GET | `api/users.php?id=1` | User detail (zonder wachtwoord) |
| GET | `api/comments.php?postId=1` | Reacties bij een bericht |
| POST | `api/comments.php` | Nieuwe reactie opslaan |

POST-body (JSON):

```json
{
  "postId": 1,
  "name": "Cristian",
  "email": "cristian@devtok.demo",
  "body": "Dit werkt."
}
```

## Projectstructuur

- `index.html` — startpagina
- `detail.html` — detailpagina
- `css/style.css` — TikTok/DevTok styling
- `js/config.js` — API-adres
- `js/app.js` — feed, categorieën, zoeken en knoppen
- `js/detail.js` — postdetail, comments en nieuwe reacties
- `api/` — PHP-API naar MySQL
- `database/devtok.sql` — schema en testdata voor phpMyAdmin
