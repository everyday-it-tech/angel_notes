// AngelNotes v0.1 — messages-first PWA (no backend)

const MESSAGES = [
  "You are not behind. You’re on a path only you can walk 💚",
  "You’ve survived 100% of your hardest days — flawless record 🌟",
  "Existing is already effort. Everything else today is extra credit 🌈",
  // TODO: paste your full message pack here
];

const $message = document.getElementById("message");
const $meta = document.getElementById("meta");
const $newBtn = document.getElementById("newBtn");
const $copyBtn = document.getElementById("copyBtn");

function pickRandom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function setMessage(text) {
  $message.textContent = text;
  const ts = new Date().toLocaleString();
  $meta.textContent = `Saved: ${ts}`;
  try {
    localStorage.setItem("angelnotes_last_message", text);
    localStorage.setItem("angelnotes_last_ts", String(Date.now()));
  } catch {}
}

function loadLastOrRandom() {
  try {
    const last = localStorage.getItem("angelnotes_last_message");
    if (last) return setMessage(last);
  } catch {}
  setMessage(pickRandom(MESSAGES));
}

$newBtn.addEventListener("click", () => {
  setMessage(pickRandom(MESSAGES));
});

$copyBtn.addEventListener("click", async () => {
  const text = $message.textContent || "";
  try {
    await navigator.clipboard.writeText(text);
    $copyBtn.textContent = "Copied!";
    setTimeout(() => ($copyBtn.textContent = "Copy"), 900);
  } catch {
    // fallback: do nothing
    $copyBtn.textContent = "Copy failed";
    setTimeout(() => ($copyBtn.textContent = "Copy"), 900);
  }
});

// Initial render
loadLastOrRandom();
