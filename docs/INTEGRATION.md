# Share Flow + Challenge Mode — Integration Guide

Implements [issue #4](https://github.com/tatinc23/retro-blaster-OG/issues/4) and the client hook for [issue #5](https://github.com/tatinc23/retro-blaster-OG/issues/5).

## Minimum wiring (one line)

Add this just before `</body>` in `docs/index.html`:

```html
<script src="share-challenge.js"></script>
```

That's it. The module self-initializes:

- Reads `?c=SCORE` from the URL, stores the challenge, and shows a
  ⚡ CHALLENGER MODE banner.
- Wraps the existing global `postScore(name)` so a share button appears at
  game over.
- If the wrapped submission path does not fire on a real game over, call
  `RBShare.onGameOver(score, wave)` explicitly from the game-over handler
  (or dispatch `window.dispatchEvent(new CustomEvent('rb:gameover',
  { detail: { score: S, wave: W } }))`).

## Recommended explicit wiring

For guaranteed timing and to use your own button styling, replace the
auto-injected button with one in the game-over markup:

```html
<button class="btn-primary" onclick="RBShare.shareScore(score, wave)">⚡ BEAT MY SCORE</button>
```

and call `RBShare.onGameOver(score, wave)` at game over. The module detects
the swap (the injected button is only a fallback) — keep whichever you
prefer.

## Behavior notes

- **Web Share API**: fires the native OS share sheet (SMS, email, WhatsApp,
  X, etc.) on mobile. Requires HTTPS + a user gesture — both satisfied by
  the button click on the live site.
- **Fallback**: on browsers without `navigator.share` (e.g., desktop
  Firefox) the score line + link are copied to the clipboard with a toast.
- **Share text** is spoiler-free (emoji bar = wave progress), built to read
  well in a social feed — the Wordle grid pattern.
- **Challenge links** (`?c=12450`) are for fun, not ranked — no signature
  needed. The leaderboard POST itself is the thing that needs integrity
  work (issue #3).

## Test checklist

- [ ] Open `/?c=12345` → banner appears; play; beat 12,345 → banner clears +
      revenge toast; share button offers the new score
- [ ] Game over → share button visible once, not duplicated
- [ ] Mobile (iOS Safari + Android Chrome): native share sheet opens with
      score line + URL
- [ ] Desktop Firefox: clipboard fallback toast works
- [ ] Share button tap outside game over doesn't stack stale scores
- [ ] After deploy: returning players get the new build (sw.js cache issue,
      see issue #6 — fix that before relying on this shipping)
