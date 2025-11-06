#!/bin/bash

################################################################################
# Automated Portfolio Deployment Script
# Repository: charan-portfolio
# This script automates: repo creation, push, GitHub Pages setup, and URL output
################################################################################

set -e  # Exit on any error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="charan-portfolio"
REPO_DESCRIPTION="Professional portfolio - Senior Platform Engineer specializing in Kafka, Cloud, and Data Engineering"
BRANCH="main"

################################################################################
# Helper Functions
################################################################################

print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

################################################################################
# Pre-flight Checks
################################################################################

print_step "STEP 0: Pre-flight Checks"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed"
    echo "Install it with: brew install gh"
    exit 1
fi
print_success "GitHub CLI is installed"

# Check if authenticated
if ! gh auth status &> /dev/null; then
    print_error "GitHub CLI is not authenticated"
    echo "Run: gh auth login"
    exit 1
fi
print_success "GitHub CLI is authenticated"

# Get GitHub username
GITHUB_USERNAME=$(gh api user --jq '.login')
print_success "GitHub username: $GITHUB_USERNAME"

# Check if we're in the correct directory
if [ ! -f "index.html" ]; then
    print_error "index.html not found. Please run this script from the web-portfolio directory."
    exit 1
fi
print_success "Portfolio files found"

echo ""

################################################################################
# STEP 1: Create GitHub Repository
################################################################################

print_step "STEP 1: Creating GitHub Repository '$REPO_NAME'"

# Check if repo already exists
if gh repo view "$GITHUB_USERNAME/$REPO_NAME" &> /dev/null; then
    print_info "Repository $REPO_NAME already exists"
    read -p "Do you want to delete and recreate it? (y/n): " RECREATE
    if [ "$RECREATE" = "y" ]; then
        print_info "Deleting existing repository..."
        gh repo delete "$GITHUB_USERNAME/$REPO_NAME" --yes
        print_success "Repository deleted"
        
        print_info "Creating new repository..."
        gh repo create "$REPO_NAME" \
            --public \
            --description "$REPO_DESCRIPTION" \
            --homepage "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"
        print_success "Repository created: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
    else
        print_info "Using existing repository"
    fi
else
    print_info "Creating new repository..."
    gh repo create "$REPO_NAME" \
        --public \
        --description "$REPO_DESCRIPTION" \
        --homepage "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"
    print_success "Repository created: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
fi

echo ""

################################################################################
# STEP 2: Initialize Git and Connect to Remote
################################################################################

print_step "STEP 2: Initializing Git Repository"

# Check if git is already initialized
if [ ! -d ".git" ]; then
    print_info "Initializing git repository..."
    git init
    git branch -M main
    print_success "Git initialized"
else
    print_success "Git already initialized"
fi

# Set remote
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
if git remote get-url origin &> /dev/null; then
    print_info "Updating remote origin..."
    git remote set-url origin "$REMOTE_URL"
else
    print_info "Adding remote origin..."
    git remote add origin "$REMOTE_URL"
fi
print_success "Remote configured: $REMOTE_URL"

echo ""

################################################################################
# STEP 3: Build and Commit Portfolio
################################################################################

print_step "STEP 3: Building and Committing Portfolio"

print_info "Staging all files..."
git add -A

print_info "Creating commit..."
COMMIT_MSG="Deploy portfolio - $(date '+%Y-%m-%d %H:%M:%S')"
if git diff --staged --quiet; then
    print_info "No changes to commit"
else
    git commit -m "$COMMIT_MSG"
    print_success "Commit created: $COMMIT_MSG"
fi

echo ""

################################################################################
# STEP 4: Push to GitHub
################################################################################

print_step "STEP 4: Pushing to GitHub"

print_info "Pushing to origin/$BRANCH..."
git push -u origin $BRANCH --force

print_success "Code pushed to GitHub successfully"

echo ""

################################################################################
# STEP 5: Enable GitHub Pages
################################################################################

print_step "STEP 5: Enabling GitHub Pages"

print_info "Configuring GitHub Pages..."

# Enable GitHub Pages using GitHub CLI
gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/${GITHUB_USERNAME}/${REPO_NAME}/pages" \
    -f source[branch]=$BRANCH \
    -f source[path]='/' \
    2>/dev/null && print_success "GitHub Pages enabled" || print_info "GitHub Pages may already be enabled"

# Wait a moment for Pages to initialize
print_info "Waiting for GitHub Pages to initialize (5 seconds)..."
sleep 5

echo ""

################################################################################
# STEP 6: Verify and Output URL
################################################################################

print_step "STEP 6: Deployment Complete!"

PAGES_URL="https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"

echo ""
print_success "🎉 Your portfolio is now live!"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📍 Portfolio URL:${NC}"
echo -e "${BLUE}   $PAGES_URL${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}📦 Repository:${NC}"
echo -e "${BLUE}   https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
echo ""
echo -e "${GREEN}⚙️  Settings:${NC}"
echo -e "${BLUE}   https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/pages${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if the page is accessible
print_info "Checking if page is live..."
sleep 2

if curl -s -o /dev/null -w "%{http_code}" "$PAGES_URL" | grep -q "200\|404"; then
    echo ""
    print_success "GitHub Pages is responding!"
    echo ""
    echo -e "${YELLOW}⚠️  Note: It may take 1-2 minutes for your site to be fully deployed.${NC}"
    echo -e "${YELLOW}   If you see a 404, wait a moment and refresh.${NC}"
else
    echo ""
    print_info "GitHub Pages is still deploying (this is normal)"
    echo -e "${YELLOW}   Your site will be live in 1-2 minutes at: $PAGES_URL${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📋 Next Steps:${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "1. 📸 Add your profile photo:"
echo "   cp /path/to/your/photo.jpg assets/profile.jpg"
echo "   git add assets/profile.jpg"
echo "   git commit -m 'Add profile photo'"
echo "   git push"
echo ""
echo "2. 📝 Update your resume with the portfolio URL:"
echo "   $PAGES_URL"
echo ""
echo "3. 💼 Add to your LinkedIn profile:"
echo "   Profile → Contact Info → Website → Add $PAGES_URL"
echo ""
echo "4. 🔄 To update your portfolio later, edit index.html and run:"
echo "   git add -A && git commit -m 'Update portfolio' && git push"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
print_success "Deployment complete! Good luck with your job search! 🚀"
echo ""

# Copy URL to clipboard (macOS)
if command -v pbcopy &> /dev/null; then
    echo "$PAGES_URL" | pbcopy
    print_success "URL copied to clipboard!"
fi

