# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A SwiftBar/xbar macOS menu bar widget that displays GitHub Copilot premium request usage. The entire plugin is a single shell script: `copilot-spending.15m.sh`.

## Architecture

Single-file plugin architecture. The script:

1. Reads `GITHUB_TOKEN` and `GITHUB_USERNAME` (hardcoded or from environment)
2. Calls the GitHub REST API: `GET /users/{username}/settings/billing/premium_request/usage?year=YYYY&month=MM`
3. Parses JSON with `jq` to extract usage counts
4. Renders SwiftBar output: menu bar title line + dropdown menu items

SwiftBar interprets the script's stdout — the first line becomes the menu bar item, subsequent lines (after `---`) become dropdown menu items. SwiftBar metadata is encoded in the filename (`15m` = refresh every 15 minutes).

## Configuration

Users edit these variables directly in the script:

```bash
GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_PAT_HERE}"
GITHUB_USERNAME="${GITHUB_USERNAME:-YOUR_GITHUB_USERNAME}"
PLAN_LIMIT=300  # 50 (Free), 300 (Pro), 1500 (Pro+)
```

## Dependencies

- `bash`, `curl`, `jq`, `bc` (macOS builtins except jq)
- `jq`: `brew install jq`
- SwiftBar or xbar installed and running

## Testing the Script

Run directly in terminal to see raw SwiftBar output:

```bash
GITHUB_TOKEN=ghp_xxx GITHUB_USERNAME=yourname bash copilot-spending.15m.sh
```

To change refresh interval, rename the file (e.g., `copilot-spending.5m.sh`, `copilot-spending.1h.sh`) — SwiftBar uses the filename interval.

## SwiftBar Output Format

```
Menu bar title | color=#hex
---
Dropdown line 1
Dropdown line 2 | href=https://...
-- refresh | refresh=true
```

Attributes after `|` are SwiftBar formatting directives.
