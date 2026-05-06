# Retro Blaster

A free, open-source arcade shooter. Play it in your browser or on mobile — no install, no account, no ads. Great for passing the time or 🚽 breaks. Can you crack the top 10 GLOBAL leaderboard?

**Play now:** [retroblaster.tatinc.us](https://retroblaster.tatinc.us)

https://raw.githubusercontent.com/tatinc23/retro-blaster/main/docs/retro-blaster.gif

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

## Deployment

This repo deploys the `docs/` directory to Cloudflare Pages using GitHub Actions.

Requirements:
- the publish directory is `docs/`
- `docs/index.html` must exist
- the Cloudflare Pages project name in `.github/workflows/deploy.yml` must match the actual Cloudflare Pages project name
- repository secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` must be configured

The current workflow installs Node and Wrangler explicitly before deployment to avoid runner issues with missing Wrangler.

---

## Project Structure

```
docs/
  index.html   # The entire game — one self-contained HTML file
  _headers     # Cloudflare Pages cache rules
ios/
  # iOS WKWebView wrapper (internal project files currently live under CallemiguelShooter/)
```

The web game lives entirely in `docs/index.html`. That's the file to edit for gameplay changes.

The iOS wrapper is a native WKWebView shell for Retro Blaster. Its current Xcode project files still use the legacy internal `CallemiguelShooter` path and target naming, but the app itself is Retro Blaster. You need an Apple Developer account and your own Team ID to build it — set `DEVELOPMENT_TEAM` in Xcode under Signing & Capabilities.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

MIT — see [LICENSE](LICENSE). Built by [TAT Inc](https://tatinc.us).
