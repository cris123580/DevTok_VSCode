const id = new URLSearchParams(window.location.search).get("id");
const detail = document.querySelector("#post-detail");
const comments = document.querySelector("#comments");
const count = document.querySelector("#count");
const form = document.querySelector("#comment-form");
const message = document.querySelector("#message");

let currentComments = [];

async function loadDetail() {
  if (!id) {
    detail.innerHTML = '<div class="empty">Geen bericht geselecteerd.</div>';
    form.style.display = "none";
    return;
  }

  try {
    const [postResponse, commentsResponse, usersResponse] = await Promise.all([
      fetch(`${DEVTOK_API}/posts.php?id=${encodeURIComponent(id)}`),
      fetch(`${DEVTOK_API}/comments.php?postId=${encodeURIComponent(id)}`),
      fetch(`${DEVTOK_API}/users.php`)
    ]);

    if (!postResponse.ok || !commentsResponse.ok || !usersResponse.ok) {
      throw new Error("API fout");
    }

    const post = await postResponse.json();
    currentComments = await commentsResponse.json();
    const users = await usersResponse.json();
    const user = users.find(item => item.id === post.userId);

    detail.innerHTML = `
      <span class="tag">${escapeHtml(post.category || "Software Development")}</span>
      <h1>${escapeHtml(capitalize(post.title))}</h1>
      <p class="detail-body">${escapeHtml(post.body)}</p>
      <div class="author detail-author">
        <div class="avatar">${user ? escapeHtml(user.name.charAt(0)) : "U"}</div>
        <div>
          <b>${user ? escapeHtml(user.name) : "Gebruiker"}</b>
          <span class="time">Auteur van dit bericht</span>
        </div>
      </div>
    `;

    renderComments();
  } catch (error) {
    console.error(error);
    detail.innerHTML = '<div class="empty">Er ging iets mis bij het laden van het bericht.</div>';
  }
}

function renderComments() {
  count.textContent = `(${currentComments.length})`;

  comments.innerHTML = currentComments.map(comment => `
    <article class="comment">
      <strong>${escapeHtml(comment.name)}</strong>
      <small>${escapeHtml(comment.email || "DevTok gebruiker")}</small>
      <p>${escapeHtml(comment.body)}</p>
    </article>
  `).join("");
}

form.addEventListener("submit", async event => {
  event.preventDefault();

  const name = document.querySelector("#name").value.trim();
  const text = document.querySelector("#text").value.trim();

  if (!name || !text) return;

  message.textContent = "Reactie plaatsen...";

  try {
    const response = await fetch(`${DEVTOK_API}/comments.php`, {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({
        postId: Number(id),
        name,
        email: `${name.toLowerCase().replace(/\s+/g, ".")}@devtok.demo`,
        body: text
      })
    });

    if (!response.ok) throw new Error("POST fout");

    const newComment = await response.json();
    currentComments.unshift(newComment);
    renderComments();
    form.reset();
    message.textContent = "Reactie opgeslagen.";
  } catch (error) {
    console.error(error);
    message.textContent = "Er ging iets mis bij het plaatsen van je reactie.";
  }
});

function capitalize(text) {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, char => ({
    "&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"
  }[char]));
}

loadDetail();
