# DevOps Automated Deployment Guide

Complete automation for deploying your portfolio to GitHub Pages using GitHub CLI.

---

## 🚀 ONE-COMMAND DEPLOYMENT

### Prerequisites
- GitHub CLI installed and authenticated
- Terminal access

### Deploy Everything Automatically

```bash
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

./auto-deploy.sh
```

**That's it!** The script will:
1. ✅ Create GitHub repository `charan-portfolio`
2. ✅ Initialize git and connect remote
3. ✅ Commit all portfolio files
4. ✅ Push to GitHub
5. ✅ Enable GitHub Pages
6. ✅ Output your live URL

Your portfolio will be live at: `https://YOUR_USERNAME.github.io/charan-portfolio/`

---

## 📋 STEP-BY-STEP (Manual Alternative)

If you prefer to run commands manually:

### Step 1: Create GitHub Repository

```bash
# Set repository name
REPO_NAME="charan-portfolio"

# Create public repository with GitHub CLI
gh repo create $REPO_NAME \
  --public \
  --description "Professional portfolio - Senior Platform Engineer" \
  --homepage "https://$(gh api user --jq '.login').github.io/${REPO_NAME}/"
```

**What this does:**
- Creates a new public repository named `charan-portfolio`
- Sets description and homepage URL
- Uses GitHub CLI to interact with GitHub API

---

### Step 2: Initialize Git and Connect Remote

```bash
# Navigate to portfolio directory
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

# Get your GitHub username
GITHUB_USERNAME=$(gh api user --jq '.login')

# Initialize git (if not already done)
git init
git branch -M main

# Add remote origin
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
```

**What this does:**
- Initializes git repository
- Renames default branch to `main`
- Connects to your GitHub repository

---

### Step 3: Commit Portfolio Files

```bash
# Stage all files
git add -A

# Create initial commit
git commit -m "Initial commit: Professional portfolio for Charan Rachumalla"
```

**What this does:**
- Stages all HTML, CSS, and asset files
- Creates a commit with your portfolio content

---

### Step 4: Push to GitHub

```bash
# Push to main branch
git push -u origin main
```

**What this does:**
- Uploads your code to GitHub
- Sets upstream tracking for future pushes

---

### Step 5: Enable GitHub Pages

```bash
# Enable GitHub Pages using GitHub API
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${GITHUB_USERNAME}/${REPO_NAME}/pages" \
  -f source[branch]=main \
  -f source[path]=/
```

**What this does:**
- Configures GitHub Pages to serve from `main` branch
- Sets root directory (`/`) as the source
- Triggers automatic deployment

---

### Step 6: Get Your Live URL

```bash
# Display your portfolio URL
echo "Your portfolio is live at: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"

# Copy URL to clipboard (macOS)
echo "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/" | pbcopy
```

**What this does:**
- Displays your live portfolio URL
- Copies it to clipboard for easy sharing

---

## 🔄 UPDATE WORKFLOW

### After Making Changes to Your Portfolio

```bash
# Navigate to portfolio directory
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

# Stage changes
git add -A

# Commit with descriptive message
git commit -m "Update: [describe your changes]"

# Push to GitHub (auto-deploys in 1-2 minutes)
git push
```

---

## 📸 ADD PROFILE PHOTO

```bash
# Copy your photo to the assets directory
cp /path/to/your/photo.jpg assets/profile.jpg

# Commit and push
git add assets/profile.jpg
git commit -m "Add professional profile photo"
git push
```

**Photo Requirements:**
- File name: `profile.jpg`
- Recommended size: 600x600 pixels (square)
- Format: JPG or PNG

---

## 🛠️ ADVANCED: CI/CD Pipeline (Optional)

### Add GitHub Actions for Automated Deployment

Create `.github/workflows/deploy.yml`:

```bash
mkdir -p .github/workflows

cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy Portfolio

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./
        publish_branch: gh-pages
EOF

git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions CI/CD pipeline"
git push
```

**What this does:**
- Automatically deploys on every push to `main`
- Provides manual deployment trigger
- Separates source code (main) from deployed site (gh-pages)

---

## 🔍 VERIFY DEPLOYMENT

### Check Deployment Status

```bash
# View repository details
gh repo view

# Check Pages status
gh api "/repos/${GITHUB_USERNAME}/${REPO_NAME}/pages" --jq '.html_url'

# Test if site is live
curl -I "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"
```

---

## 🐛 TROUBLESHOOTING

### Issue: GitHub CLI not authenticated

```bash
# Login to GitHub
gh auth login

# Follow the prompts to authenticate
```

---

### Issue: Repository already exists

```bash
# Delete existing repository
gh repo delete $REPO_NAME --yes

# Re-run auto-deploy.sh
./auto-deploy.sh
```

---

### Issue: GitHub Pages not enabled

```bash
# Manually enable via web interface
open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/pages"

# Or use GitHub CLI
gh api \
  --method POST \
  "/repos/${GITHUB_USERNAME}/${REPO_NAME}/pages" \
  -f source[branch]=main \
  -f source[path]=/
```

---

### Issue: 404 on deployed site

```bash
# Wait 1-2 minutes for deployment
sleep 120

# Check again
curl -I "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"

# Force rebuild by pushing a commit
git commit --allow-empty -m "Trigger rebuild"
git push
```

---

## 📊 MONITORING & ANALYTICS

### View Deployment History

```bash
# View commit history
git log --oneline --graph --decorate -10

# View GitHub deployments
gh api "/repos/${GITHUB_USERNAME}/${REPO_NAME}/deployments" --jq '.[].created_at'
```

### Add Google Analytics (Optional)

Add before `</head>` in `index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=YOUR_GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'YOUR_GA_ID');
</script>
```

Then commit and push:

```bash
git add index.html
git commit -m "Add Google Analytics tracking"
git push
```

---

## 🔐 SECURITY BEST PRACTICES

### Use SSH for Git (Recommended)

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "charanreddy.rachumalla@gmail.com"

# Add SSH key to GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub --title "Charan's MacBook"

# Update remote to use SSH
git remote set-url origin "git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
```

### Use Personal Access Token (PAT)

```bash
# Create PAT with repo scope
gh auth refresh -s repo

# Your credentials are now stored securely
```

---

## 📈 PERFORMANCE OPTIMIZATION

### Minify HTML/CSS (Optional)

```bash
# Install minify tool
npm install -g html-minifier clean-css-cli

# Minify HTML
html-minifier --collapse-whitespace --remove-comments \
  --minify-css true --minify-js true \
  index.html -o index.min.html

# Use minified version
mv index.html index.original.html
mv index.min.html index.html

# Commit
git add -A
git commit -m "Optimize: Minify HTML/CSS"
git push
```

---

## 🎯 QUICK REFERENCE

### Most Common Commands

```bash
# Deploy from scratch
./auto-deploy.sh

# Update portfolio
git add -A && git commit -m "Update content" && git push

# Check status
gh repo view

# View live site
open "https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"

# View GitHub settings
open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/pages"
```

---

## 📞 SUPPORT

### Useful Links

- **GitHub CLI Docs**: https://cli.github.com/manual/
- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **Git Docs**: https://git-scm.com/doc
- **Portfolio Repository**: `https://github.com/${GITHUB_USERNAME}/${REPO_NAME}`

### Check System Status

```bash
# GitHub CLI version
gh --version

# Git version
git --version

# Verify authentication
gh auth status

# View current repository
git remote -v
```

---

## ✅ POST-DEPLOYMENT CHECKLIST

- [ ] Portfolio is live and accessible
- [ ] Profile photo added
- [ ] Links work (email, LinkedIn, phone)
- [ ] Responsive on mobile devices (test with DevTools)
- [ ] Print-to-PDF works correctly
- [ ] URL added to resume
- [ ] URL added to LinkedIn profile
- [ ] URL added to email signature
- [ ] Shared with your network

---

**🎉 Congratulations! Your portfolio is now live and professionally deployed!**

Built with DevOps best practices | Automated deployment | GitHub Pages hosting

