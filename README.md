# Retro Blaster

A free, open-source arcade shooter. Play it in your browser or on mobile — no install, no account, no ads. Great for passing the time or 🚽 breaks. Can you crack the top 10 GLOBAL leaderboard?

**Play now:** [retroblaster.tatinc.us](https://retroblaster.tatinc.us)

---

## How to Play

| Control | Action |
|---------|--------|
| Touch / drag | Move your plane (mobile) |
| WASD / Arrow keys | Move your plane (desktop) |
| Auto-fire | Always on — just dodge and survive |
| ESC | Pause |

Grab power-ups (⚡) to unlock side fighters and weapon upgrades. Shield (🛡️) gives you 5 seconds of invincibility. Boss waves appear every 5 rounds.

---

## Run Locally

No build step. Just open the file:

```bash
git clone https://github.com/tatinc23/retro-blaster.git
cd retro-blaster
open docs/index.html
```

Or serve it with any static file server:

```bash
npx serve docs
```

---

## Project Structure

```
docs/
  index.html   # The entire game — one self-contained HTML file
  _headers     # Cloudflare Pages cache rules
CallemiguelShooter/
  # iOS WKWebView wrapper (internal name — requires Apple Developer account to build)
```

The web game lives entirely in `docs/index.html`. That's the file to edit for gameplay changes.

The `CallemiguelShooter/` folder is an iOS Xcode project (internal name) that wraps the game in a native WebView. You need an Apple Developer account and your own Team ID to build it — set `DEVELOPMENT_TEAM` in Xcode under Signing & Capabilities.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

MIT — see [LICENSE](LICENSE). Built by [TAT Inc](https://tatinc.us).
