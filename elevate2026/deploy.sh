#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Deploy the Web Summit 2026 site to digibc.org/elevate2026
#
# Reads SSH_ALIAS and REMOTE_PATH from ./.env. Auth uses the SSH key
# configured under the alias in ~/.ssh/config (no password in repo).
#
# Usage:
#   ./deploy.sh                    # deploy to $REMOTE_PATH from .env
#   ./deploy.sh some/other/path    # override remote path
# ----------------------------------------------------------------------------

set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f .env ]]; then
  echo "ERROR: .env not found in $(pwd)." >&2
  exit 1
fi

# shellcheck disable=SC1091
set -a; source .env; set +a

: "${SSH_ALIAS:?SSH_ALIAS not set in .env}"

REMOTE_PATH="${1:-${REMOTE_PATH:-public/elevate2026}}"

echo "Deploying $(pwd)"
echo "       -> ${SSH_ALIAS}:${REMOTE_PATH}"
echo

ssh "$SSH_ALIAS" "mkdir -p '${REMOTE_PATH}'"

rsync -avzP --delete \
  --exclude='.DS_Store' \
  --exclude='.env' \
  --exclude='.gitignore' \
  --exclude='.git/' \
  --exclude='*.ttf' \
  --exclude='assets/fonts/Veneer/' \
  --exclude='digibc-logo.png' \
  --exclude='deploy.sh' \
  --exclude='CLAUDE.md' \
  -e "ssh" \
  ./ "${SSH_ALIAS}:${REMOTE_PATH}/"

echo
echo "Done. Visit: https://digibc.org/elevate2026/"
