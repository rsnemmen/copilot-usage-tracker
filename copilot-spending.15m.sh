#!/bin/bash

# <xbar.title>GitHub Copilot Usage</xbar.title>
# <xbar.version>v3.0</xbar.version>
# <xbar.desc>Shows GitHub Copilot premium request usage percentage</xbar.desc>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# ========== CONFIGURATION ==========
# Set these directly here, OR export COPILOT_TOKEN, COPILOT_USERNAME
# and COPILOT_PLAN in your .zshrc / .zshenv / .bashrc
GITHUB_TOKEN=""
GITHUB_USERNAME=""

# Your Copilot plan's monthly limit:
#   Free: 50 | Pro: 300 | Pro+: 1500
PLAN_LIMIT=""
# ===================================

COPILOT_ICON="iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAdklEQVR42tWTUQoAIQhEO8Cep3t2mU7SeZz2Q8KVLG2/GpBikAdOmdJNwlvEp7yHAJ7aQiywp3eoBUDNgtBhjlMQFnAyHuOjwiapQLPoyUboRWdwOtrI0AI9alSwFwZhAoIHhL8gadRAPnX1yz0r4F6T3c5dog7saV5VqvluAAAAAABJRU5ErkJggg=="

# === Grab credentials from environment if not set in script ===

load_env_var() {
    local var_name="$1"
    local val=""

    # Method 1: Environment variable (works in terminal)
    eval val="\${$var_name}"
    [ -n "$val" ] && echo "$val" && return

    # Method 2: from .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        val=$(grep "^export ${var_name}=" "$HOME/.zshrc" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
        [ -n "$val" ] && echo "$val" && return
    fi

    # Method 3: from .zshenv
    if [ -f "$HOME/.zshenv" ]; then
        val=$(grep "^export ${var_name}=" "$HOME/.zshenv" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
        [ -n "$val" ] && echo "$val" && return
    fi

    # Method 4: from .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        val=$(grep "^export ${var_name}=" "$HOME/.bashrc" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
        [ -n "$val" ] && echo "$val" && return
    fi
}

format_quantity() {
    local quantity="$1"

    quantity="${quantity%0}"
    quantity="${quantity%.}"
    printf '%s' "$quantity"
}

# Script values take priority; fall back to env vars
if [ -z "$GITHUB_TOKEN" ]; then
    GITHUB_TOKEN="$(load_env_var COPILOT_TOKEN)"
fi
if [ -z "$GITHUB_USERNAME" ]; then
    GITHUB_USERNAME="$(load_env_var COPILOT_USERNAME)"
fi
if [ -z "$PLAN_LIMIT" ]; then
    PLAN_LIMIT="$(load_env_var COPILOT_PLAN)"
fi
PLAN_LIMIT="${PLAN_LIMIT:-300}"

if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_USERNAME" ]; then
    echo "! | templateImage=${COPILOT_ICON}"
    echo "---"
    echo "Missing credentials."
    echo "Set COPILOT_TOKEN and COPILOT_USERNAME"
    echo "in .zshrc/.bashrc or in the script."
    exit 0
fi

current_year=$(date +%Y)
current_month=$(date +%-m)

response=$(curl -s -w "\n%{http_code}" \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/users/$GITHUB_USERNAME/settings/billing/premium_request/usage?year=$current_year&month=$current_month" 2>&1)

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [[ "$http_code" != "200" ]]; then
    echo ":exclamationmark.triangle.fill: Err | sfcolor=red"
    echo "---"
    echo "HTTP $http_code"
    echo "Refresh | refresh=true"
    exit 0
fi

total_float=$(echo "$body" | jq '[.usageItems[] | select(.product == "Copilot") | .grossQuantity] | add // 0')
total_requests=$(format_quantity "$total_float")

pct=$(echo "scale=1; $total_float * 100 / $PLAN_LIMIT" | bc)
pct_int=${pct%.*}
[[ $pct_int -gt 100 ]] && pct="100.0"

if [[ $pct_int -lt 50 ]]; then
    color="#3fb950"
elif [[ $pct_int -lt 80 ]]; then
    color="#d29922"
else
    color="#f85149"
fi

bar_len=10
filled=$((pct_int * bar_len / 100))
empty=$((bar_len - filled))
bar=$(printf '▓%.0s' $(seq 1 $filled 2>/dev/null) || echo "")
bar+=$(printf '░%.0s' $(seq 1 $empty 2>/dev/null) || echo "")

echo "${pct}% | color=$color sfcolor=$color templateImage=${COPILOT_ICON}"
echo "---"
echo "Premium Requests (personal billing) | size=11 color=gray"
echo "$bar ${total_requests}/${PLAN_LIMIT} | font=Menlo size=13 color=$color"
echo "GitHub may show higher usage when Copilot is billed to an org or university. | size=11 color=gray"
echo "---"
days_left=$(( $(date -v1d -v+1m +%s) - $(date +%s) ))
days_left=$((days_left / 86400))
echo "Resets in $days_left days | size=12 color=gray"
echo "---"
echo "View on GitHub Billing | href=https://github.com/settings/billing"
echo "View Copilot Settings | href=https://github.com/settings/copilot/features"
echo "Refresh | refresh=true"
