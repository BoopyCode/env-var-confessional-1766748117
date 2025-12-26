#!/usr/bin/env bash
# Env Var Confessional - Where your environment variables come to confess their sins
# Usage: ./env_confessional.sh [.env.example]

set -euo pipefail

# The sacred text containing all the variables we should have
TEMPLATE_FILE="${1:-.env.example}"

# Check if the template exists (it probably doesn't, like your motivation on Monday)
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "ERROR: Can't find '$TEMPLATE_FILE' - Did you look under the couch?" >&2
    echo "Usage: $0 [.env.example]" >&2
    exit 1
fi

# Read the template and prepare for judgment
mapfile -t EXPECTED_VARS < <(grep -v '^#' "$TEMPLATE_FILE" | grep -v '^$' | cut -d= -f1)

# Track our sinners and saints
MISSING=0
PRESENT=0

echo "🔍 Environment Variable Inquisition Begins!"
echo "========================================="

# Judge each variable with the mercy of a sleep-deprived developer
for var in "${EXPECTED_VARS[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "❌ '$var' is MISSING - Probably off getting coffee"
        ((MISSING++))
    else
        echo "✅ '$var' is present - Value: '${!var:0:20}$([[ ${#!var} -gt 20 ]] && echo '...')'"
        ((PRESENT++))
    fi
    sleep 0.05  # Dramatic pause for effect

done

# Deliver the verdict
echo "\n📊 Final Judgment:"
echo "   Present: $PRESENT"
echo "   Missing: $MISSING"

if [[ $MISSING -gt 0 ]]; then
    echo "\n💀 $MISSING variables are in timeout. Check your .env file!"
    exit 1
else
    echo "\n🎉 All variables accounted for! You may proceed to the next bug."
    exit 0
fi
