# AGENTS.md

## Purpose

This repository contains a single-file SwiftBar/xbar plugin that shows GitHub Copilot premium request usage.

Primary code file:

- `copilot-spending.15m.sh`

Agents working here should optimize for correctness, minimalism, and preserving SwiftBar output behavior.

## Repository Shape

- Single shell script plugin; there is no app framework, package manager, or test runner.
- `README.md` explains installation and user-facing behavior.
- `CLAUDE.md` contains repo-specific guidance that should be treated as part of the local conventions.
- No existing `AGENTS.md` was present when this file was created.

## Local Instruction Files

Checked for additional agent rules:

- No `.cursorrules` file found.
- No `.cursor/rules/` directory found.
- No `.github/copilot-instructions.md` file found.

If any of those files are added later, treat them as higher-priority repo instructions and update this file.

## Architecture Notes

The script currently does all of the following in one file:

- Stores or loads credentials and plan settings.
- Falls back to environment variables and shell rc files.
- Calls the GitHub billing API with `curl`.
- Parses JSON with `jq`.
- Computes percentages and progress bar display.
- Prints SwiftBar menu output to stdout.

SwiftBar behavior depends on stdout structure:

- First line is the menu bar item.
- `---` starts the dropdown menu.
- Lines may include SwiftBar attributes after `|`.

Do not casually reorder or reformat output lines without considering SwiftBar rendering.

## Dependencies

Runtime dependencies:

- `bash`
- `curl`
- `jq`
- `bc`

Platform assumptions:

- macOS
- SwiftBar or xbar
- BSD `date` support (`date -v...` is used)

## Build Commands

There is no formal build step.

Useful validation commands:

```bash
bash -n copilot-spending.15m.sh
chmod +x copilot-spending.15m.sh
```

If you need to install missing dependencies locally:

```bash
brew install jq bc
```

SwiftBar deployment is file-based rather than build-based; users copy the script into their plugins directory.

## Lint Commands

No lint configuration is checked into the repo.

Preferred ad hoc linting:

```bash
bash -n copilot-spending.15m.sh
shellcheck copilot-spending.15m.sh
```

Notes:

- `shellcheck` is recommended but optional; it is not declared or enforced by repo config.
- Treat `bash -n` as the minimum pre-merge syntax validation.

## Test Commands

There is no automated test suite in this repository.

Primary manual test command:

```bash
COPILOT_TOKEN=ghp_xxx COPILOT_USERNAME=yourname COPILOT_PLAN=300 bash copilot-spending.15m.sh
```

This prints the raw SwiftBar output for inspection.

Useful focused checks:

```bash
bash -n copilot-spending.15m.sh
COPILOT_TOKEN=ghp_xxx COPILOT_USERNAME=yourname COPILOT_PLAN=300 bash copilot-spending.15m.sh
```

## Running a Single Test

There is no single-test framework because no automated tests exist.

For the equivalent of a targeted test, run one focused manual scenario at a time:

- Syntax only: `bash -n copilot-spending.15m.sh`
- Happy path API run: `COPILOT_TOKEN=... COPILOT_USERNAME=... COPILOT_PLAN=300 bash copilot-spending.15m.sh`
- Missing credentials path: `bash copilot-spending.15m.sh`

If you add automated tests later, document the exact per-test command here.

## Important Behavior To Notice

The script prefers values set directly in the file, then falls back to:

- `GITHUB_TOKEN`
- `GITHUB_USERNAME`
- `PLAN_LIMIT`
- and then `COPILOT_*` environment variables:

- `COPILOT_TOKEN`
- `COPILOT_USERNAME`
- `COPILOT_PLAN`

Agents should follow the code, not stale docs, unless intentionally updating both.

## Editing Expectations

- Keep the plugin as a single shell script unless the user explicitly asks for a structural rewrite.
- Preserve executable script compatibility on macOS `/bin/bash`.
- Prefer incremental edits over broad rewrites.
- Preserve SwiftBar metadata comments at the top of the file.
- Preserve filename-based refresh semantics unless the user explicitly wants a rename.

## Code Style Guidelines

### Shell and Compatibility

- Write for Bash, but stay compatible with the older Bash version shipped on macOS when practical.
- Avoid Bash features that require a modern GNU/Linux-only shell environment.
- Assume BSD utilities, not GNU-specific flags.

### Formatting

- Use 4-space indentation inside functions and conditionals, matching the existing script.
- Keep logically related sections separated by short blank lines.
- Prefer lines short enough to scan in terminal editors; wrap long commands with continuation indentation.
- Keep top-level sections clearly labeled when that improves readability.

### Imports / External Commands

- There are no language-level imports; external tools are invoked as shell commands.
- Prefer built-in shell features when they are simpler and clearer.
- Use external commands only when they materially improve clarity or capability.
- Current external commands include `curl`, `jq`, `bc`, `grep`, `cut`, `tr`, `tail`, `sed`, `seq`, and `date`.

### Quoting and Expansion

- Quote variable expansions by default: `"$var"`.
- Only leave expansions unquoted when intentional word splitting or globbing is required.
- Quote paths and user-provided values.
- Be especially careful around tokens, usernames, and API responses.

### Variable Naming

- Use uppercase for configuration-style globals and environment-driven values.
- Use lowercase for local variables and temporary computation values.
- Use descriptive names such as `current_month`, `http_code`, `total_requests`, and `days_left`.
- Avoid one-letter variable names except for very short-lived shell idioms.

### Functions

- Prefer small helper functions for repeated or distinct behavior.
- Declare function-local variables with `local`.
- Keep functions single-purpose.
- Return output via stdout only when that pattern is already natural for shell.

### Types and Data Handling

- Shell has only strings; be explicit where values are treated as integers or decimals.
- Use `jq` for JSON parsing instead of ad hoc text parsing.
- Use `bc` only for decimal math that Bash cannot do safely.
- Trim or normalize API-derived numeric values before integer comparisons when needed.

### Error Handling

- Fail gracefully in user-facing output; this plugin should show a useful menu state instead of crashing.
- Prefer explicit checks for missing credentials, HTTP errors, and empty API results.
- When an API call fails, print concise SwiftBar-friendly diagnostics.
- Avoid leaking secrets in error messages.
- If adding stricter shell options like `set -e`, review every command path carefully first; do not add them casually.

### Output and UX

- Treat stdout as the product surface.
- Keep the first line compact; it is the menu bar label.
- Keep dropdown lines informative but short.
- Preserve valid SwiftBar attribute syntax after `|`.
- When adding menu items, ensure the output still reads cleanly in both menu bar and dropdown contexts.

### Comments

- Keep comments for configuration, SwiftBar metadata, or non-obvious logic.
- Do not restate obvious shell syntax.
- Update comments when behavior changes.

### Naming Conventions For New Logic

- Config constants: uppercase, e.g. `PLAN_LIMIT`.
- Helper functions: lowercase snake_case, e.g. `load_env_var`.
- Computed locals: lowercase snake_case, e.g. `total_float`.

### Dependencies and Portability

- Do not introduce new dependencies unless the user asks or the value is clear.
- If adding a dependency, update `README.md` and this file.
- Prefer commands commonly available on macOS.

## Change Checklist For Agents

Before finishing code changes, try to do as many of these as apply:

- Run `bash -n copilot-spending.15m.sh`.
- If available, run `shellcheck copilot-spending.15m.sh`.
- Run one manual scenario with `COPILOT_TOKEN`, `COPILOT_USERNAME`, and `COPILOT_PLAN` set.
- Confirm the SwiftBar output still has a first line, `---`, and sensible menu entries.
- Update `README.md` if user-facing setup or behavior changed.
- Update this file if commands or conventions changed.

## When Making Documentation Changes

- Keep docs aligned with the actual script behavior.
- Prefer documenting `COPILOT_*` environment variables unless the code changes.
- Call out any intentional mismatch resolution in the final response.

## Safe Defaults For Future Agents

- Assume no automated tests exist unless new test files are added.
- Assume manual validation is required for behavior changes.
- Assume user-facing output stability matters more than clever refactors.
- Assume unrelated working tree changes should be left untouched.
