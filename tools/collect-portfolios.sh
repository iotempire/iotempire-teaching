#!/usr/bin/env bash
# Collect student portfolios — instructor helper.
#
#   ./tools/collect-portfolios.sh invitations            # show pending invitations
#   ./tools/collect-portfolios.sh accept [--dry-run]     # accept all pending invitations
#   ./tools/collect-portfolios.sh list [--pattern RE]    # list matching collaborator repos
#   ./tools/collect-portfolios.sh clone [--dir DIR] [--pattern RE] [--depth N]
#
# Students create their repository from the template in one click and invite the
# instructor. This script accepts the invitations in bulk and clones the matching
# repositories for review. It never writes to a student repository.
#
# Requires: gh (authenticated: `gh auth login`) and git.

set -euo pipefail

DEFAULT_PATTERN='^net-iot-hsbi-20[0-9]{2}-portfolio$'
PATTERN="$DEFAULT_PATTERN"
DIR="."
DEPTH=""
DRY_RUN=0

usage() {
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

need_gh() {
    command -v gh >/dev/null 2>&1 || { echo "error: gh is not installed. See https://cli.github.com/" >&2; exit 1; }
    gh auth status >/dev/null 2>&1 || { echo "error: gh is not authenticated. Run: gh auth login" >&2; exit 1; }
}

parse_flags() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --pattern) PATTERN="${2:?--pattern needs a value}"; shift 2 ;;
            --dir)     DIR="${2:?--dir needs a value}"; shift 2 ;;
            --depth)   DEPTH="${2:?--depth needs a value}"; shift 2 ;;
            --dry-run) DRY_RUN=1; shift ;;
            -h|--help) usage 0 ;;
            *) echo "error: unknown option: $1" >&2; usage 1 ;;
        esac
    done
}

list_collaborator_repos() {
    # `gh repo list` cannot list collaborator repos; the API can.
    # The pattern is matched against the repository NAME (the part after the
    # owner), because every student's repository is called the same thing.
    gh api "user/repos?affiliation=collaborator&per_page=100" --paginate \
        --jq '.[].full_name' \
        | awk -F/ -v re="$PATTERN" '$NF ~ re' | sort || true
}

cmd_invitations() {
    need_gh
    local ids
    ids="$(gh api user/repository_invitations --paginate --jq '.[].id' || true)"
    if [ -z "$ids" ]; then
        echo "No pending repository invitations."
        return 0
    fi
    gh api user/repository_invitations --paginate \
        --jq '.[] | "\(.id)\t\(.repository.full_name)\t\(.inviter.login)"'
    echo
    echo "Run '$0 accept' to accept all of them."
}

cmd_accept() {
    need_gh
    if [ "$DRY_RUN" = 1 ]; then
        echo "DRY RUN — nothing will be accepted."
    fi
    local ids id
    ids="$(gh api user/repository_invitations --paginate --jq '.[].id' || true)"
    if [ -z "$ids" ]; then
        echo "No pending repository invitations."
        return 0
    fi
    for id in $ids; do
        if [ "$DRY_RUN" = 1 ]; then
            echo "would accept invitation $id"
        else
            gh api -X PATCH "user/repository_invitations/$id" >/dev/null
            echo "accepted invitation $id"
        fi
    done
}

cmd_list() {
    need_gh
    local repos
    repos="$(list_collaborator_repos)"
    if [ -z "$repos" ]; then
        echo "No collaborator repositories match: $PATTERN"
        echo "(Students who have not invited you cannot be listed. Check with '$0 invitations'.)"
        return 0
    fi
    echo "$repos"
    echo
    echo "$(printf '%s\n' "$repos" | wc -l | tr -d ' ') repositories match: $PATTERN"
}

cmd_clone() {
    need_gh
    mkdir -p "$DIR"
    local repos repo name target
    repos="$(list_collaborator_repos)"
    if [ -z "$repos" ]; then
        echo "No collaborator repositories match: $PATTERN"
        return 0
    fi
    for repo in $repos; do
        # Student repositories share one name, so the directory carries the owner.
        name="${repo//\//__}"          # owner__repo
        target="$DIR/$name"
        if [ -e "$target" ]; then
            echo "skip  $repo (already in $target)"
            continue
        fi
        if [ "$DRY_RUN" = 1 ]; then
            echo "would clone $repo -> $target"
            continue
        fi
        if [ -n "$DEPTH" ]; then
            gh repo clone "$repo" "$target" -- --depth "$DEPTH" >/dev/null
        else
            gh repo clone "$repo" "$target" >/dev/null
        fi
        echo "clone $repo -> $target"
    done
}

case "${1:-}" in
    invitations) shift; parse_flags "$@"; cmd_invitations ;;
    accept)      shift; parse_flags "$@"; cmd_accept ;;
    list)        shift; parse_flags "$@"; cmd_list ;;
    clone)       shift; parse_flags "$@"; cmd_clone ;;
    -h|--help|"") usage 0 ;;
    *) echo "error: unknown command: $1" >&2; usage 1 ;;
esac
