#!/usr/bin/env bash
# Claude Code status line
# Located at ~/.dotfiles/claude/.claude/statusline.sh
# Stow with: cd ~/.dotfiles && stow claude

input=$(cat)

# ── Model ────────────────────────────────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# ── Thinking / effort mode ────────────────────────────────────────────────────
thinking=$(echo "$input" | jq -r '.thinking.enabled // false')
effort=$(echo "$input" | jq -r '.effort.level // empty')

if [ "$thinking" = "true" ]; then
  if [ -n "$effort" ]; then
    mode_label="think:${effort}"
  else
    mode_label="think"
  fi
elif [ -n "$effort" ]; then
  mode_label="plan:${effort}"
else
  mode_label=""
fi

# ── Context window ────────────────────────────────────────────────────────────
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

if [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  ctx_k=$(echo "$ctx_size" | awk '{printf "%dk", $1/1000}')
  ctx_label="ctx:$(printf '%.0f' "$used_pct")%/${ctx_k}"
else
  ctx_label="ctx:--"
fi

# ── Rate limits ───────────────────────────────────────────────────────────────
now=$(date +%s)

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
five_label=""
if [ -n "$five_pct" ] && [ -n "$five_reset" ]; then
  secs_left=$(( five_reset - now ))
  if [ "$secs_left" -le 0 ]; then
    reset_str="now"
  else
    hrs=$(( secs_left / 3600 ))
    mins=$(( (secs_left % 3600) / 60 ))
    if [ "$hrs" -gt 0 ]; then
      reset_str="${hrs}h${mins}m"
    else
      reset_str="${mins}m"
    fi
  fi
  five_label="5h:$(printf '%.0f' "$five_pct")%(rst:${reset_str})"
fi

seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
seven_label=""
if [ -n "$seven_pct" ] && [ -n "$seven_reset" ]; then
  secs_left7=$(( seven_reset - now ))
  if [ "$secs_left7" -le 0 ]; then
    reset_str7="now"
  else
    hrs7=$(( secs_left7 / 3600 ))
    mins7=$(( (secs_left7 % 3600) / 60 ))
    days7=$(( hrs7 / 24 ))
    hrs7r=$(( hrs7 % 24 ))
    if [ "$days7" -gt 0 ]; then
      reset_str7="${days7}d${hrs7r}h"
    elif [ "$hrs7" -gt 0 ]; then
      reset_str7="${hrs7}h${mins7}m"
    else
      reset_str7="${mins7}m"
    fi
  fi
  seven_label="7d:$(printf '%.0f' "$seven_pct")%(rst:${reset_str7})"
fi

# ── Git branch ────────────────────────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# ── Worktree ──────────────────────────────────────────────────────────────────
worktree_name=$(echo "$input" | jq -r '.worktree.name // empty')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // empty')
if [ -n "$worktree_name" ]; then
  if [ -n "$worktree_branch" ]; then
    branch="${worktree_branch}(wt:${worktree_name})"
  else
    branch="${branch}(wt:${worktree_name})"
  fi
fi

# ── Vim mode ──────────────────────────────────────────────────────────────────
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# ── Session name ──────────────────────────────────────────────────────────────
session_name=$(echo "$input" | jq -r '.session_name // empty')

# ── Assemble parts ────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
DIM='\033[2m'
RESET='\033[0m'

parts=()

# Model (cyan)
parts+=("$(printf "${CYAN}%s${RESET}" "$model")")

# Mode label (yellow) — only when present
if [ -n "$mode_label" ]; then
  parts+=("$(printf "${YELLOW}%s${RESET}" "$mode_label")")
fi

# Context (green)
parts+=("$(printf "${GREEN}%s${RESET}" "$ctx_label")")

# Rate limits (red when high, yellow otherwise)
if [ -n "$five_label" ]; then
  five_num=$(printf '%.0f' "$five_pct")
  if [ "$five_num" -ge 80 ]; then
    parts+=("$(printf "${RED}%s${RESET}" "$five_label")")
  else
    parts+=("$(printf "${YELLOW}%s${RESET}" "$five_label")")
  fi
fi

if [ -n "$seven_label" ]; then
  seven_num=$(printf '%.0f' "$seven_pct")
  if [ "$seven_num" -ge 80 ]; then
    parts+=("$(printf "${RED}%s${RESET}" "$seven_label")")
  else
    parts+=("$(printf "${YELLOW}%s${RESET}" "$seven_label")")
  fi
fi

# Git branch (magenta)
if [ -n "$branch" ]; then
  parts+=("$(printf "${MAGENTA}%s${RESET}" "$branch")")
fi

# Session name (dim) — only when set
if [ -n "$session_name" ]; then
  parts+=("$(printf "${DIM}[%s]${RESET}" "$session_name")")
fi

# Vim mode (bold) — only when active
if [ -n "$vim_mode" ]; then
  parts+=("$(printf '\033[1m[%s]\033[0m' "$vim_mode")")
fi

# Join with separator
sep="$(printf "${DIM} | ${RESET}")"
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="${result}${sep}${part}"
  fi
done

printf "%b\n" "$result"
