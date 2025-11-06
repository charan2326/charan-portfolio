#!/bin/bash

# Deployment script for charanrachumallaadventures portfolio
# This script will push your portfolio to GitHub

set -e  # Exit on error

echo "🚀 Deploying Charan's Portfolio to GitHub..."
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found. Please run this script from the web-portfolio directory."
    exit 1
fi

# Prompt for GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Error: GitHub username cannot be empty."
    exit 1
fi

# Check if git remote already exists
if git remote get-url origin &> /dev/null; then
    echo "✅ Git remote 'origin' already exists"
    REMOTE_URL=$(git remote get-url origin)
    echo "   Current remote: $REMOTE_URL"
    read -p "Do you want to keep this remote? (y/n): " KEEP_REMOTE
    if [ "$KEEP_REMOTE" != "y" ]; then
        git remote remove origin
        git remote add origin "https://github.com/${GITHUB_USERNAME}/charanrachumallaadventures.git"
        echo "✅ Remote updated"
    fi
else
    git remote add origin "https://github.com/${GITHUB_USERNAME}/charanrachumallaadventures.git"
    echo "✅ Remote added: https://github.com/${GITHUB_USERNAME}/charanrachumallaadventures.git"
fi

echo ""
echo "📝 Committing any new changes..."

# Add README and DEPLOY_INSTRUCTIONS if not already committed
git add README.md DEPLOY_INSTRUCTIONS.md 2>/dev/null || true
git commit -m "Add README and deployment instructions" 2>/dev/null || echo "   No new changes to commit"

echo ""
echo "⬆️  Pushing to GitHub..."
echo ""

# Push to GitHub
git push -u origin main

echo ""
echo "✅ Success! Your portfolio has been pushed to GitHub!"
echo ""
echo "📍 Next steps:"
echo "   1. Go to https://github.com/${GITHUB_USERNAME}/charanrachumallaadventures"
echo "   2. Click 'Settings' → 'Pages'"
echo "   3. Set Source to 'main' branch, '/ (root)' folder"
echo "   4. Click 'Save'"
echo "   5. Wait 1-2 minutes"
echo ""
echo "🌐 Your portfolio will be live at:"
echo "   https://${GITHUB_USERNAME}.github.io/charanrachumallaadventures/"
echo ""
echo "⚠️  Don't forget to add your profile photo at assets/profile.jpg!"
echo ""

