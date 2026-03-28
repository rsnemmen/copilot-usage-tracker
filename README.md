# GitHub Copilot Usage Widget for macOS

A SwiftBar/xbar menu bar widget that shows your GitHub Copilot personal premium request usage.

## Features

- Shows usage percentage in the menu bar with a Copilot icon
- Displays a wide progress bar in the dropdown
- Shows used requests, plan limit, and days until reset
- Links to GitHub Billing and Copilot settings
- Falls back to `COPILOT_*` environment variables when credentials are not hardcoded

## Screenshot

<p align="center">
  <img src="screenshot.png" alt="Copilot Usage Widget" width="300">
</p>

## Requirements

- macOS
- [SwiftBar](https://github.com/swiftbar/SwiftBar) or [xbar](https://xbarapp.com/)
- [jq](https://jqlang.github.io/jq/)
- `bc`
- A GitHub Personal Access Token with Copilot billing permissions

## Installation

### 1. Install dependencies

```bash
brew install jq bc
```

### 2. Create a GitHub Personal Access Token

1. Go to [GitHub Token Settings](https://github.com/settings/tokens?type=beta)
2. Click **Generate new token** (fine-grained)
3. Give it a name like `Copilot Usage Widget`
4. Under **Account permissions**, enable **Plan** → **Read-only**
5. Generate and copy the token

### 3. Configure the plugin

Copy `copilot-spending.15m.sh` to your SwiftBar plugins folder, then either:

- edit the script and set `GITHUB_TOKEN`, `GITHUB_USERNAME`, and `PLAN_LIMIT` directly, or
- export `COPILOT_TOKEN`, `COPILOT_USERNAME`, and `COPILOT_PLAN` in `~/.zshrc`, `~/.zshenv`, or `~/.bashrc`

Plan limits:

- Free: `50`
- Pro: `300`
- Pro+: `1500`

### 4. Make it executable

```bash
chmod +x /path/to/plugins/copilot-spending.15m.sh
```

### 5. Refresh SwiftBar

Click the SwiftBar icon → Refresh All

## Quick Validation

Run the plugin directly to inspect the raw SwiftBar output:

```bash
COPILOT_TOKEN=ghp_xxx COPILOT_USERNAME=yourname COPILOT_PLAN=300 bash copilot-spending.15m.sh
```

Syntax check:

```bash
bash -n copilot-spending.15m.sh
```

## Refresh Interval

The filename `copilot-spending.15m.sh` sets refresh to every 15 minutes. Rename to change it:

- `copilot-spending.5m.sh` → 5 minutes
- `copilot-spending.1h.sh` → 1 hour

## Troubleshooting

**"Missing credentials." in the menu bar**

- Set `COPILOT_TOKEN` and `COPILOT_USERNAME`, or hardcode `GITHUB_TOKEN` and `GITHUB_USERNAME` in the script

**"Err" showing in the menu bar**

- Check that your token has Plan read permission
- Verify your username is correct
- Confirm `COPILOT_PLAN` or `PLAN_LIMIT` matches your Copilot plan

**Usage looks higher than expected**

- GitHub may show higher usage when Copilot is billed to an organization or university

**Widget not appearing**

- Ensure SwiftBar is running
- Check the plugin is in your SwiftBar plugins folder
- Verify the file is executable (`chmod +x`)

## License

MIT
