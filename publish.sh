#!/usr/bin/env bash
# publish.sh — Initialize git repo and publish to GitHub
#
# Usage:
#   1. cd into the claude-frontend-style/ folder
#   2. bash publish.sh
#   3. Follow the printed instructions
#
# Or for a one-shot run with GitHub CLI installed and authenticated:
#   bash publish.sh --gh USERNAME

set -e

# ---- Colors ----
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "🚀 Claude Frontend Style — Publish Script"
echo "─────────────────────────────────────────"
echo ""

# ---- Pre-flight checks ----
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed.${NC}"
    echo "   Install: https://git-scm.com/downloads"
    exit 1
fi

if [ ! -f "SKILL.md" ]; then
    echo -e "${RED}❌ SKILL.md not found in current directory.${NC}"
    echo "   Make sure you're running this from inside the claude-frontend-style/ folder."
    exit 1
fi

echo -e "${GREEN}✓${NC} Git installed"
echo -e "${GREEN}✓${NC} SKILL.md found"
echo ""

# ---- Configure git user (if not set globally) ----
if [ -z "$(git config user.name)" ]; then
    echo -e "${YELLOW}⚠${NC}  Git user.name is not set."
    read -p "   Enter your name: " GIT_NAME
    git config user.name "$GIT_NAME"
fi

if [ -z "$(git config user.email)" ]; then
    echo -e "${YELLOW}⚠${NC}  Git user.email is not set."
    read -p "   Enter your email: " GIT_EMAIL
    git config user.email "$GIT_EMAIL"
fi

# ---- Init repo ----
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠${NC}  Already a git repo — skipping init"
else
    echo -e "${BLUE}📦${NC} Initializing git repo (branch: main)..."
    git init -b main > /dev/null 2>&1 || git init > /dev/null && git checkout -b main > /dev/null 2>&1 || true
fi

# ---- Stage and commit ----
echo -e "${BLUE}📝${NC} Staging files..."
git add .

if git diff --staged --quiet; then
    echo -e "${YELLOW}ℹ${NC}  No changes to commit (already committed?)"
else
    echo -e "${BLUE}💾${NC} Creating initial commit..."
    git commit -m "Initial release: Claude Frontend Style v1.0.0

Visual design system (Claude.com aesthetic) + frontend development
standards (10 commandments + 30-item self-check) packaged as a
Claude Skill for team distribution.

Includes:
- SKILL.md with trigger description tuned for high recall
- references/design-system.md — visual specification
- references/development-standards.md — code quality rules
- assets/design-system-demo.html — live component reference
- claude-frontend-style.skill — ready-to-upload package
- README, CHANGELOG, USAGE, LICENSE (MIT)" > /dev/null
    echo -e "${GREEN}✓${NC} Commit created"
fi

echo ""
echo -e "${GREEN}✅ Local repo is ready.${NC}"
echo ""

# ---- Branch to GitHub ----

# Option A: gh CLI shortcut
if [ "$1" == "--gh" ] && [ -n "$2" ]; then
    USERNAME="$2"
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}❌ GitHub CLI (gh) not installed.${NC}"
        echo "   Install: https://cli.github.com"
        exit 1
    fi
    echo -e "${BLUE}🌐${NC} Creating GitHub repo via gh CLI..."
    gh repo create "$USERNAME/claude-frontend-style" \
        --public \
        --description "Claude.com style + production frontend standards, packaged as a Claude Skill" \
        --source=. \
        --remote=origin \
        --push
    echo ""
    echo -e "${GREEN}✅ Published to GitHub!${NC}"
    echo "   https://github.com/$USERNAME/claude-frontend-style"
    exit 0
fi

# Option B: Manual instructions
echo "📡 Next steps to publish to GitHub"
echo "─────────────────────────────────────"
echo ""
echo -e "${BLUE}Option A — Using GitHub CLI${NC} (recommended if you have 'gh' installed):"
echo ""
echo -e "    ${GREEN}bash publish.sh --gh YOUR_GITHUB_USERNAME${NC}"
echo ""
echo "    (This creates the repo AND pushes in one command.)"
echo ""
echo -e "${BLUE}Option B — Manual via browser:${NC}"
echo ""
echo "    1. Open https://github.com/new"
echo "    2. Repository name: claude-frontend-style"
echo "    3. Description: Claude.com style + production frontend standards, packaged as a Claude Skill"
echo "    4. Choose Public or Private"
echo "    5. DO NOT initialize with README, .gitignore, or LICENSE (we already have them)"
echo "    6. Click 'Create repository'"
echo "    7. Run these commands (replace YOUR_USERNAME):"
echo ""
echo -e "       ${GREEN}git remote add origin https://github.com/YOUR_USERNAME/claude-frontend-style.git${NC}"
echo -e "       ${GREEN}git push -u origin main${NC}"
echo ""
echo "📋 After publishing, also recommended:"
echo "   • Go to repo Settings → Topics → add: 'claude', 'skill', 'frontend', 'design-system'"
echo "   • Edit the repo description and website field"
echo "   • Create a release: Releases → Draft new release → tag v1.0.0 → attach claude-frontend-style.skill"
echo ""
