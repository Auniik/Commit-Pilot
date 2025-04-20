#!/bin/bash

HOOK_PATH=".git/hooks/prepare-commit-msg"
SOURCE_PATH=".hooks/prepare-commit-msg"

if ! command -v fzf >/dev/null || ! command -v jq >/dev/null; then
  echo "⚠️  Please install both 'fzf' and 'jq' for an epic, interactive experience! 🎟️✨"
  echo ""
  echo "👉 Install on macOS:  brew install fzf jq"
  echo "👉 Install on Ubuntu: sudo apt install fzf jq"
  exit 1
fi

options=("JIRA" "GitHub")
issue_provider=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select your issue tracker: ")

if [[ -z "$issue_provider" ]]; then
  echo "❌ No option selected. Exiting."
  exit 1
fi

# Handle JIRA setup
if [[ "$issue_provider" == "JIRA" ]]; then
  read -p "Enter your JIRA email: " jira_user
  while ! [[ "$jira_user" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
    echo "❗ Invalid email format. Please try again."
    read -p "Enter your JIRA email: " jira_user
  done

  echo ""
  echo "🔐 You need a JIRA API Token to proceed."
  echo "👉 Visit: https://id.atlassian.com/manage/api-tokens"
  echo ""

  if command -v xdg-open &> /dev/null; then
    xdg-open https://id.atlassian.com/manage/api-tokens
  elif command -v open &> /dev/null; then
    open https://id.atlassian.com/manage/api-tokens
  fi

  read -s -p "Enter your JIRA API token: " jira_token
  echo ""

  while [[ -z "$jira_token" ]]; do
    echo "❗ Token cannot be empty. Please try again."
    read -s -p "Enter your JIRA API token: " jira_token
  done
fi

# Ask for time logging (if JIRA)
log_time="true"
if [[ "$issue_provider" == "JIRA" ]]; then
  read -p "🕓 Enable time logging for JIRA? (Y/n): " log_choice
  case "$log_choice" in
    [nN][oO]|[nN]) log_time="false" ;;
    *) log_time="true" ;;
  esac
fi

# Confirm overwrite
if [ -f "$HOOK_PATH" ]; then
  read -p "⚠️  Hook already exists at $HOOK_PATH. Overwrite? (Y/n): " confirm
  case "$confirm" in
    [nN][oO]|[nN])
      echo "❌ Aborted. Existing hook not overwritten."
      exit 1
      ;;
    *) ;;
  esac
fi

# Replace variables in hook file
sed -e "s|__PROVIDER__|$issue_provider|g" \
    -e "s|__JIRA_USER__|$jira_user|g" \
    -e "s|__JIRA_API_TOKEN__|$jira_token|g" \
    -e "s|__ENABLE_TIMELOG__|$log_time|g" \
    "$SOURCE_PATH" > "$HOOK_PATH"

chmod +x "$HOOK_PATH"
echo "✅ Git hook installed successfully at $HOOK_PATH"
