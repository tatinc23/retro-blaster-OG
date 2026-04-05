# Claude Code Global Instructions

## GitHub Copilot Agent Runs

**NEVER attempt to diagnose or fix a failed GitHub Copilot agent run by analyzing its logs alone.**

When a Copilot run fails with `CAPIError`, `BodyTimeoutError`, `HTTP/2 GOAWAY`, or firewall warnings:
- These are **infrastructure failures** (network/firewall blocking the Copilot agent's API calls), not code bugs
- Do NOT re-run the job or attempt retries — each run costs money and time
- **Immediately tell the user** what the root cause is and what they need to do manually (e.g. add a host to the firewall allow list, re-run from their side)
- Do not read through 250KB of logs trying to find a code fix — there is none

## General Cost Awareness

- If a task involves repeated API calls, retries, or polling, flag the cost impact to the user before proceeding
- Prefer one clear answer over multiple exploratory attempts

## Node / Wrangler Environment

- Node is managed via nvm — always prefix: `export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"`
- `gh` and `wrangler` are at `/usr/local/bin/` — add `export PATH="/usr/local/bin:$PATH"` when needed
- `GITHUB_TOKEN` env var may be set in shell and overrides gh keyring — prefix commands with `GITHUB_TOKEN=""`
- Wrangler OAuth token is at `~/Library/Preferences/.wrangler/config/default.toml` (has zone:read but NOT zone:write)
- Cloudflare account ID: `d6a266be494cf336045c669dd5438b2b` (TAT_Inc_)
- Pages project: `callemiguel-shooter-ios` → deploys to `callemiguel-shooter-ios.pages.dev` and `retroblaster.tatinc.us`
- Deploy command: `cd /private/tmp/claude-501/pages-deploy && GITHUB_TOKEN="" wrangler pages deploy . --project-name=callemiguel-shooter-ios --branch=main`

## iOS Repo

- iOS repo: `tatinc23/callemiguel-shooter-ios` — push files via `gh api --method PUT`
- Game HTML source of truth: `/private/tmp/claude-501/pages-deploy/index.html` — sync to iOS repo after changes
- `DEVELOPMENT_TEAM` placeholder still in `project.pbxproj` — user must set in Xcode manually

## Preview Server

- Local preview server (port 7432) serves static files but does NOT hot-reload — call `location.reload()` via `preview_eval` after edits
- Preview shows desktop viewport (~750px wide); game wraps to 480px max-width so layout looks off — trust mobile for final verification

## Cloudflare DNS

- Wrangler OAuth token lacks `zone:write` — cannot create DNS records programmatically
- To add DNS records: Cloudflare Dashboard → tatinc.us → DNS (manual step, ~30 seconds)
