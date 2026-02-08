#!/bin/bash
set -e

echo "=== LURCHES DEPLOYMENT ==="
echo ""

# 1. Git setup
if [ ! -d .git ]; then
  echo "→ Initializing git repo..."
  git init
  git add -A
  git commit -m "Initial commit: Lurches genetic simulation sandbox

Single-file HTML/JS game — genetic simulation sandbox rebuilt from
a 1992 Turbo Pascal original. Features 8-gene genetic system,
toroidal world, god mode with disasters/blessings, VFX system,
event timeline, and find-champion buttons.

Built with Claude."
fi

# 2. GitHub repo
echo ""
echo "→ Creating GitHub repo..."
gh repo create lurches --public --source=. --remote=origin --push 2>/dev/null || {
  echo "  (repo may already exist, pushing...)"
  git remote add origin https://github.com/$(gh api user -q .login)/lurches.git 2>/dev/null || true
  git push -u origin main 2>/dev/null || git push -u origin master
}

# 3. Fly.io deploy
echo ""
echo "→ Deploying to Fly.io..."
if ! flyctl status 2>/dev/null; then
  echo "  Creating Fly app..."
  flyctl launch --no-deploy --copy-config --yes
fi
flyctl deploy

# 4. Custom domain
echo ""
echo "→ Setting up lurches.net domain..."
flyctl certs add lurches.net
flyctl certs add www.lurches.net

echo ""
echo "============================================"
echo "  DEPLOYED!"
echo ""
echo "  Fly URL: https://lurches.fly.dev"
echo "  Custom:  https://lurches.net (once DNS is set)"
echo ""
echo "  DNS RECORDS TO SET:"
echo "  lurches.net     → A     66.241.124.XXX  (check 'flyctl ips list')"
echo "  lurches.net     → AAAA  2a09:8280:1::XX (check 'flyctl ips list')"
echo "  www.lurches.net → CNAME lurches.fly.dev"
echo "============================================"
