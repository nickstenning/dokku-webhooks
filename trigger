#!/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x
source "$(dirname $0)/../common/functions"
source "$(dirname $0)/config"

ACTION=$1; APP=$2; shift; shift

join () {
  IFS=$1; shift; echo "$*"
}

dokku_log_info1 "Running webhooks for $ACTION"

[[ -f "$HOOKS_FILE" ]] || exit 0

PAYLOAD=$(join '&' action=$ACTION app=$APP host=$(hostname -f) "$@")

while read url; do
  dokku_log_info2_quiet "$url"
  if ! curl -sSL -X POST -d "$PAYLOAD" -o/dev/null "$url"; then
      dokku_log_warn "Failed to post webhook to '$url'. Continuing..."
  fi
done < "$HOOKS_FILE"
