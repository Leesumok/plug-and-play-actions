#!/usr/bin/env bash
set -euo pipefail

# Updates the current issue's body using gh CLI.
# Issue number is read from the GitHub event payload.
#
# Usage:
#   ./scripts/update-issue-body.sh "New body content here"

BODY="${1:-}"

if [[ -z "$BODY" ]]; then
  echo "Error: body content is required as first argument" >&2
  exit 1
fi

ISSUE=$(jq -r '.issue.number // empty' "${GITHUB_EVENT_PATH:?GITHUB_EVENT_PATH not set}")
if ! [[ "$ISSUE" =~ ^[0-9]+$ ]]; then
  echo "Error: no issue number in event payload" >&2
  exit 1
fi

gh issue edit "$ISSUE" --body "$BODY"
echo "Successfully updated issue #$ISSUE body"
