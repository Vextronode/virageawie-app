#!/usr/bin/env bash
# Copies the rules in .AI/ to the locations each coding tool reads.
# Safe to run repeatedly. Works in Git Bash on Windows.
#   bash .AI/scripts/sync.sh          sync from the current .AI/ checkout
#   bash .AI/scripts/sync.sh --pull   update .AI/ (git pull --ff-only) first
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if [ ! -f .AI/RULES.md ]; then
    echo "sync: .AI/RULES.md not found; run this from the main working tree with the .AI worktree present" >&2
    exit 1
fi

if [ "${1:-}" = "--pull" ]; then
    echo "sync: updating .AI (git pull --ff-only)"
    git -C .AI pull --ff-only
fi

copy() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
        echo "sync: unchanged  $dest"
    else
        cp "$src" "$dest"
        echo "sync: wrote      $dest"
    fi
}

copy .AI/RULES.md AGENTS.md
copy .AI/RULES.md .github/copilot-instructions.md
copy .AI/tools/claude-settings.json .claude/settings.json

if [ "$(cat CLAUDE.md 2> /dev/null || true)" = "@AGENTS.md" ]; then
    echo "sync: unchanged  CLAUDE.md"
else
    printf '%s\n' '@AGENTS.md' > CLAUDE.md
    echo "sync: wrote      CLAUDE.md"
fi

exclude_file="$(git rev-parse --git-common-dir)/info/exclude"
mkdir -p "$(dirname "$exclude_file")"
touch "$exclude_file"
# Older versions of this script anchored these four patterns to the root; replace them.
for legacy in "/AGENTS.md" "/CLAUDE.md" "/.claude/" "/.codex/"; do
    if grep -qxF "$legacy" "$exclude_file"; then
        grep -vxF "$legacy" "$exclude_file" > "$exclude_file.tmp" || true
        mv "$exclude_file.tmp" "$exclude_file"
        echo "sync: removed    $legacy (replaced by ${legacy#/})"
    fi
done

# /.AI/ and /.github/copilot-instructions.md stay anchored to the repository root;
# the tool files are matched at any depth.
for line in "/.AI/" "AGENTS.md" "CLAUDE.md" ".claude/" ".codex/" "/.github/copilot-instructions.md"; do
    if grep -qxF "$line" "$exclude_file"; then
        echo "sync: excluded   $line"
    else
        printf '%s\n' "$line" >> "$exclude_file"
        echo "sync: added      $line to $exclude_file"
    fi
done

echo "sync: done"
