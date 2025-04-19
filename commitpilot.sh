#!/bin/bash

HOOK_PATH=".git/hooks/prepare-commit-msg"
SOURCE_PATH=".hooks/prepare-commit-msg"

# Prompt for JIRA credentials
read -p "Enter your JIRA email: " jira_user
# Validate email format

while ! [[ "$jira_user" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
  echo "❗ Invalid email format. Please try again."
  read -p "Enter your JIRA email: " jira_user
done

while [[ -z "$jira_user" ]]; do
  echo "❗ Email cannot be empty. Please try again."
  read -p "Enter your JIRA email: " jira_user
done

echo ""
echo "🔐 You need a JIRA API Token to proceed."
echo "👉 Visit the link below to generate one:"
echo "   https://id.atlassian.com/manage/api-tokens"
echo "   1. Click 'Create Classic API token'"
echo "   2. Give it a label like 'COMMIT_HOOK_SCRIPT'"
echo "   3. Copy the token and paste it below"
echo ""

# Try to open the URL in the user's default browser
if command -v xdg-open &> /dev/null; then
  xdg-open https://id.atlassian.com/manage/api-tokens
elif command -v open &> /dev/null; then
  open https://id.atlassian.com/manage/api-tokens
elif command -v start &> /dev/null; then
  start https://id.atlassian.com/manage/api-tokens
else
  echo "⚠️ Could not auto-open browser. Please open the URL manually."
fi

read -s -p "Enter your JIRA API token: " jira_token

while [[ -z "$jira_token" ]]; do
  echo "❗ Token cannot be empty. Please try again."
  read -s -p "Enter your JIRA API token: " jira_token
done
echo ""

# Export them for current shell session
export JIRA_USER="$jira_user"
export JIRA_API_TOKEN="$jira_token"

echo "✅ JIRA credentials have been set for this session."

# Check if source hook file exists
if [ ! -f "$SOURCE_PATH" ]; then
  echo "❌ Source hook file not found at $SOURCE_PATH"
  exit 1
fi

# Confirm if existing hook should be overwritten
if [ -f "$HOOK_PATH" ]; then
  read -p "⚠️  Hook already exists at $HOOK_PATH. Overwrite? (y/N): " confirm
  case "$confirm" in
    [yY][eE][sS]|[yY])
      ;;
    *)
      echo "❌ Aborted. Existing hook not overwritten."
      exit 1
      ;;
  esac
fi

# Install the hook
sed "s|JIRA_USER|$jira_user|g; s|JIRA_API_TOKEN|$jira_token|g" "$SOURCE_PATH" > "$HOOK_PATH"
chmod +x "$HOOK_PATH"
echo "✅ Git hook installed successfully at $HOOK_PATH"