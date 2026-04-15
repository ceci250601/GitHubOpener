#!/usr/bin/env bash
set -euo pipefail

# Select Account (choose authentication identity)
ACCOUNTS=("ceciliacavosi-unitn" "ceci250601")

ACCOUNT=$(printf "%s\n" "${ACCOUNTS[@]}" | fzf --prompt="Scegli l’account GitHub: ")
if [ -z "$ACCOUNT" ]; then
    echo "Nessun account selezionato."
    exit 1
fi

# Switch user
gh auth switch --user "$ACCOUNT" 2>/dev/null

# List repos where you have push permission (owner or collaborator)
REPO=$(gh api user/repos --jq '.[] | select(.permissions.push == true) | .full_name' \
      | fzf --prompt="Scegli il repository: ")

if [ -z "$REPO" ]; then
    echo "Nessun repository selezionato."
    exit 1
fi

# Open selected repo in browser
gh repo view "$REPO" --web

#Allow browser to launch before terminal closes
sleep 1
