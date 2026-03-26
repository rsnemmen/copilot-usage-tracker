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

COPILOT_ICON="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"

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
total_requests=${total_float%.*}

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
echo "Premium Requests | size=11 color=gray"
echo "$bar ${total_requests}/${PLAN_LIMIT} | font=Menlo size=13 color=$color"
echo "---"
days_left=$(( $(date -v1d -v+1m +%s) - $(date +%s) ))
days_left=$((days_left / 86400))
echo "Resets in $days_left days | size=12 color=gray"
echo "---"
echo "View on GitHub | href=https://github.com/settings/copilot/features"
echo "Refresh | refresh=true"
