# ✈️ CommitPilot

**CommitPilot** is a smart Git commit hook that transforms your plain commit process into a powerful workflow assistant. It integrates JIRA issue linking, emoji tagging, and time logging — all directly from your terminal using Bash, `fzf`, and `jq`.

> 🎯 Perfect for developers who want cleaner commits, accurate work logs, and effortless ticket tracking.

---

## 🚀 Features

- 🔍 Interactive JIRA ticket selection using `fzf`
- 🔠 Automatically inserts JIRA ticket ID into commit message
- ✨ Adds contextual emoji based on commit keywords (`fix`, `add`, `refactor`, etc.)
- ⏱️ Prompts to log time directly to JIRA after commit
- 📦 Works with both CLI and GUI Git clients (e.g., PhpStorm, VS Code)
- 🔁 Gracefully falls back to manual input if `fzf` is unavailable or cancelled

---

## 🖼️ Example

```bash
❯ git commit -m "Removed unused Docker images"

📅  Last commit:  ⏱️ 1h 25m ago  
👉  Log it? Or was that another 'meeting'? 😏  
🧮  TAP-42 has 2h remaining.  
⏱️  Time spent (e.g., 1h 30m): 1h

✅  Logged 1h to TAP-42 with message: "[TAP-42] ⚰️ Removed unused Docker images"
```

---

## ⚙️ Setup

### 1. Install dependencies

```bash
brew install fzf jq       # macOS
sudo apt install fzf jq   # Ubuntu/Debian
```

### 2. Run the setup script

Run the interactive installer to configure your Git hook:

```bash
chmod +x commitpilot.sh

./commitpilot.sh
```

This script will:
- Prompt for your JIRA email and API token
- Inject credentials into the hook
- Install it as `.git/hooks/prepare-commit-msg`

---

### 3. Configure JIRA credentials in the script

Edit the script and update these lines:

```bash
jira_user="your.email@company.com"
jira_token="your-jira-api-token"
jira_url="https://yourteam.atlassian.net"
```

---

## 🔧 Customization

You can tweak:

- ✅ Emoji mappings (`✨`, `🐛`, `🔥`, etc.)
- ✅ Keyword detection logic
- ✅ Time prompt format and regex validation
- ✅ Fallback behavior for non-interactive terminals

Everything is just Bash — so you can extend it however you like.

---

## 🧪 Tested With

- ✅ Git CLI
- ✅ Bash 5+
- ✅ macOS Ventura
- ✅ JIRA Cloud API v2 and v3

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

```
MIT License © 2025 Anik Datta
```

> ✅ Feel free to fork, adapt, and integrate CommitPilot into your own workflow or team setup.

---

## 🙌 Acknowledgements

CommitPilot was built for terminal-first devs who:
- Value commit clarity ✅  
- Hate writing the same ticket ID every time 😤  
- Actually want to log their work 🧠  
- Appreciate emoji ✨

---

## 🛫 Ready to take off?

Let your commits fly — with clarity, context, and care.

---
