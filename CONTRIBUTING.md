# Contributing to Retro Blaster

Thanks for wanting to help. This is a single-file HTML5 game — easy to hack on.

## Quick Start

```bash
git clone https://github.com/tatinc23/retro-blaster.git
cd retro-blaster
open docs/index.html   # or: npx serve docs
```

No build tools, no dependencies. Edit `docs/index.html` and refresh your browser.

## Deployment Notes

This repo deploys the `docs/` directory to Cloudflare Pages using GitHub Actions.

Workflow expectations:
- the publish directory is `docs/`
- `docs/index.html` must exist
- the Cloudflare Pages project name must match the workflow value (`retro-blaster`)
- repository secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` must be configured

If deployment fails, check `.github/workflows/deploy.yml` first and verify that the Cloudflare Pages project name has not drifted from the repo/app name.

## What to Work On

Good first contributions:

- **New enemy types** — add a new enemy shape/behavior in the `spawnWave()` function
- **New power-up types** — extend the `mkPowerup()` / `applyPU()` functions
- **Boss improvements** — boss logic lives in `updateBoss()` / `spawnBoss()`
- **Mobile feel** — touch controls, haptics, visual feedback
- **Performance** — the game loop is in `loop()`, draw calls in `draw()`
- **Accessibility** — color contrast, keyboard-only play

## How to Submit a PR

1. Fork the repo
2. Create a branch: `git checkout -b feat/your-thing`
3. Make your changes in `docs/index.html`
4. Test on both desktop and mobile (Chrome DevTools device mode works fine)
5. Open a PR with a short description of what changed and why

## Ground Rules

- Keep it a single file — no bundlers, no npm, no frameworks
- No paid features, no ads, no tracking — this game is free forever
- Test on mobile before submitting (it's primarily a touch game)
- Keep the file size reasonable — the whole game should stay under 100KB

## iOS Wrapper

The `CallemiguelShooter/` Xcode project is out of scope for most contributors. It requires an Apple Developer account. Don't worry about it unless you're specifically working on iOS.

## Questions

Open an issue or reach out at [tatinc.us](https://tatinc.us).
