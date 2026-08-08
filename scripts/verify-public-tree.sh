#!/usr/bin/env bash

# Verifies that the committed public tree stays free of known private records
# and common credential formats. Run before publishing and in CI.

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: Run this script from inside the repository."
  exit 1
fi

restricted_paths='(^|/)(00_EXECUTIVE_COMMAND_CENTER|02_OPERATIONAL_LEDGERS|05_DOMAIN_COMMAND_CENTERS|06_CURRENT_STATE|07_KNOWLEDGE_LAYER|output|\.codex|\.agents)(/|$)|(^|/)\.env($|\.)|\.(pdf|docx|mp4|mov|jpg|jpeg|png|heic|tar\.gz|zip)$'
credential_patterns='-----BEGIN( [A-Z]+)? PRIVATE KEY-----|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|(api[_ -]?key|secret|password|token)[[:space:]]*[:=]|Authorization:[[:space:]]*Bearer[[:space:]]+[A-Za-z0-9._-]+'

failures=0

echo "Checking tracked paths..."
if git ls-files | grep -E "$restricted_paths"; then
  echo "ERROR: A restricted path is tracked."
  failures=1
fi

echo "Checking tracked content for credential formats..."
if git grep -n -I -i -E -e "$credential_patterns" -- ':!scripts/verify-public-tree.sh'; then
  echo "ERROR: A possible credential was found in tracked content."
  failures=1
fi

echo "Checking the publishable archive..."
if git archive --format=tar HEAD | tar -tf - | grep -E "$restricted_paths"; then
  echo "ERROR: A restricted path would be included in the published archive."
  failures=1
fi

if [ "$failures" -ne 0 ]; then
  exit 1
fi

echo "PASS: The public tree contains no restricted paths or obvious credentials."
