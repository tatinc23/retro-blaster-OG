# Claude Code Global Instructions

## GitHub Copilot Agent Runs

**NEVER attempt to diagnose or fix a failed GitHub Copilot agent run by analyzing its logs alone.**

When a Copilot run fails with `CAPIError`, `BodyTimeoutError`, `HTTP/2 GOAWAY`, or firewall warnings:
- These are **infrastructure failures** (network/firewall blocking the Copilot agent's API calls), not code bugs
- Do NOT re-run the job or attempt retries — each run costs money and time
- **Immediately tell the user** what the root cause is and what they need to do manually
- Do not read through 250KB of logs trying to find a code fix — there is none

## General Cost Awareness

- If a task involves repeated API calls, retries, or polling, flag the cost impact to the user before proceeding
- Prefer one clear answer over multiple exploratory attempts

## Node / Wrangler Environment

- Node is managed via nvm — always prefix: `export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"`
- `gh` and `wrangler` are at `/usr/local/bin/` — add `export PATH="/usr/local/bin:$PATH"` when needed
- `GITHUB_TOKEN` env var may be set in shell and overrides gh keyring — prefix commands with `GITHUB_TOKEN=""`

## Project: Retro Blaster

- **Repo:** tatinc23/callemiguel-shooter-ios | **Local:** `/Users/cawc/Github/callemiguel-shooter-ios`
- **Live:** retroblaster.tatinc.us | **CF Pages project:** `callemiguel-shooter-ios` (tatinc23 org)
- **Source of truth (web):** `docs/index.html` — edit this file only for web changes
- **iOS file:** `CallemiguelShooter/Resources/game.html` — iOS-specific (fixed viewport, dvh). Do NOT edit unless working on iOS. Currently out of sync with docs/index.html intentionally (iOS blocked on Apple Dev enrollment).
- **CF Pages build output dir:** `docs` — must be set in CF Pages Settings → Build configuration. If blank, CF serves repo root (wrong file).
- **Deploy:** `git push origin main` → CF Pages auto-deploys. Verify deployment succeeded in Deployments tab before declaring done. Curl the live URL to confirm correct code is serving.
- **Leaderboard worker:** `https://retro-blaster-leaderboard.chris-d6a.workers.dev` — `GET /scores` returns `[{name,score,wave,created_at}]`, `POST /scores` accepts `{name,score,wave}`
- **Cache:** `docs/_headers` sets `Cache-Control: no-cache` on HTML — do not remove this file
- **`DEVELOPMENT_TEAM`** placeholder still in `project.pbxproj` — user must set in Xcode manually

## Preview Server

- Local preview server (port 7432) slows Ken's Mac — use CF Pages deploys for verification instead
- Preview shows desktop viewport (~750px wide); game wraps to 480px max-width — trust mobile for final verification

## Cloudflare DNS

- Wrangler OAuth token lacks `zone:write` — cannot create DNS records programmatically
- To add DNS records: Cloudflare Dashboard → tatinc.us → DNS (manual step, ~30 seconds)
