const container = document.querySelector("#posts");
const searchBtn = document.querySelector("#searchBtn");
const searchBox = document.querySelector("#searchBox");
const searchInput = document.querySelector("#searchInput");
const toast = document.querySelector("#toast");

const POSTS_API = `${DEVTOK_API}/posts.php`;
const USERS_API = `${DEVTOK_API}/users.php`;

let allPosts = [];
let users = [];
let selectedCategory = "Alle";

const categories = ["PHP", "JavaScript", "VueJS"];

function showToast(text) {
  toast.textContent = text;
  toast.classList.add("show");
  setTimeout(() => toast.classList.remove("show"), 1800);
}

async function loadPosts() {
  console.log("Loading posts...");
  try {
    const [postsResponse, usersResponse] = await Promise.all([
      fetch(POSTS_API),
      fetch(USERS_API)
    ]);
    if (!postsResponse.ok || !usersResponse.ok) throw new Error("API fout");

    allPosts = await postsResponse.json();
    users = await usersResponse.json();
    renderPosts();
  } catch (error) {
    console.error(error);
    container.innerHTML = '<div class="empty">De berichten konden niet worden geladen.<br>Controleer je internetverbinding.</div>';
  }
}

function renderPosts() {
  const query = searchInput.value.trim().toLowerCase();

  const filtered = allPosts.filter(post => {
    const category = post.category || categories[(post.id - 1) % categories.length];
    const matchesCategory = selectedCategory === "Alle" || category === selectedCategory;
    const matchesSearch = !query ||
      post.title.toLowerCase().includes(query) ||
      post.body.toLowerCase().includes(query);
    return matchesCategory && matchesSearch;
  }).slice(0, 20);

  if (!filtered.length) {
    container.innerHTML = '<div class="empty">Geen berichten gevonden.</div>';
    return;
  }

  container.innerHTML = "";

  filtered.forEach(post => {
    const category = post.category || categories[(post.id - 1) % categories.length];
    const user = users.find(item => item.id === post.userId);

    const article = document.createElement("article");
    article.className = "post";
    article.innerHTML = `
      <div class="content">
        <span class="tag">${category}</span>
        <h2>${escapeHtml(capitalize(post.title))}</h2>
        <p class="description">${escapeHtml(post.body)}</p>
        <div class="author">
          <div class="avatar">${user ? escapeHtml(user.name.charAt(0)) : "U"}</div>
          <div>
            <b>${user ? escapeHtml(user.name) : "Gebruiker"}</b>
            <span class="time">Via DevTok API • tik om te openen</span>
          </div>
        </div>
      </div>

      <div class="actions">
        <button class="action like" aria-label="Vind ik leuk">♥<small>${12 + post.id}</small></button>
        <button class="action comment-btn" aria-label="Reacties">💬<small>${post.commentCount ?? 0}</small></button>
        <button class="action bookmark" aria-label="Opslaan">🔖</button>
      </div>
    `;

    article.addEventListener("click", event => {
      if (event.target.closest(".action")) return;
      window.location.href = `detail.html?id=${post.id}`;
    });

    article.querySelector(".like").addEventListener("click", event => {
      event.stopPropagation();
      event.currentTarget.classList.toggle("active");
      showToast(event.currentTarget.classList.contains("active") ? "Vind-ik-leuk toegevoegd" : "Vind-ik-leuk verwijderd");
    });

    article.querySelector(".comment-btn").addEventListener("click", event => {
      event.stopPropagation();
      window.location.href = `detail.html?id=${post.id}#comments`;
    });

    article.querySelector(".bookmark").addEventListener("click", event => {
      event.stopPropagation();
      event.currentTarget.classList.toggle("active");
      showToast(event.currentTarget.classList.contains("active") ? "Bericht opgeslagen" : "Opgeslaan verwijderd");
    });

    container.appendChild(article);
  });
}

function capitalize(text) {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

function escapeHtml(value) {
  return value.replace(/[&<>"']/g, char => ({
    "&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"
  }[char]));
}

searchBtn.addEventListener("click", () => {
  searchBox.classList.toggle("hidden");
  if (!searchBox.classList.contains("hidden")) searchInput.focus();
});

searchInput.addEventListener("input", renderPosts);

document.querySelectorAll(".category").forEach(button => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".category").forEach(item => item.classList.remove("active"));
    button.classList.add("active");
    selectedCategory = button.dataset.category;
    renderPosts();
  });
});

document.querySelector("#newBtn").addEventListener("click", event => {
  event.preventDefault();
  showToast("Nieuwe berichten toevoegen komt in de volgende versie.");
});

loadPosts();
