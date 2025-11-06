# Deploy Instructions for charanrachumallaadventures

Your portfolio is ready to deploy! Follow these steps:

## Step 1: Create the GitHub Repository

### Option A: Using GitHub Web Interface (Easiest)
1. Go to https://github.com/new
2. Repository name: `charanrachumallaadventures`
3. Description: "Professional portfolio showcasing my work in data engineering, Kafka streaming, and cloud platforms"
4. Make it **Public** (required for GitHub Pages)
5. **DO NOT** initialize with README, .gitignore, or license
6. Click "Create repository"

### Option B: Using GitHub CLI
```bash
gh repo create charanrachumallaadventures --public --description "Professional portfolio showcasing my work in data engineering, Kafka streaming, and cloud platforms"
```

## Step 2: Push Your Portfolio to GitHub

Run these commands in your terminal:

```bash
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

# Add the remote repository (replace YOUR_GITHUB_USERNAME with your actual username)
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/charanrachumallaadventures.git

# Push to GitHub
git push -u origin main
```

**Replace `YOUR_GITHUB_USERNAME`** with your actual GitHub username!

## Step 3: Enable GitHub Pages

1. Go to your repository on GitHub: `https://github.com/YOUR_GITHUB_USERNAME/charanrachumallaadventures`
2. Click **Settings** (top menu)
3. Scroll down to **Pages** (left sidebar)
4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/ (root)`
5. Click **Save**
6. Wait 1-2 minutes for deployment

## Step 4: Get Your Live URL

Your portfolio will be live at:

```
https://YOUR_GITHUB_USERNAME.github.io/charanrachumallaadventures/
```

## Step 5: Add Your Profile Photo (IMPORTANT!)

Before sharing your portfolio, add your photo:

1. Save your professional photo as `profile.jpg` (600x600px recommended)
2. Place it in: `web-portfolio/assets/profile.jpg`
3. Commit and push:

```bash
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

git add assets/profile.jpg
git commit -m "Add profile photo"
git push
```

## Step 6: Update Your Resume & LinkedIn

Add your portfolio link:
- Resume: Add under contact info or as a header link
- LinkedIn: Update "Website" field in Contact Info section
- Email signature: Include the link

---

## Troubleshooting

### If you get "permission denied" when pushing:
You may need to authenticate. Use a Personal Access Token (PAT):
1. Go to https://github.com/settings/tokens
2. Generate new token (classic)
3. Select `repo` scope
4. Use the token as your password when prompted

### If GitHub Pages shows 404:
- Wait 2-3 minutes after enabling Pages
- Check that `index.html` is in the root directory
- Verify the branch is set to `main` in Pages settings

### To update your portfolio later:
```bash
cd /Users/charan/Library/CloudStorage/OneDrive-AlignTechnology,Inc/work_align/kafka_repos/kafka_ops_healthcheck_services/web-portfolio

# Make your changes to index.html or other files
git add -A
git commit -m "Update portfolio content"
git push
```

Changes will be live in 1-2 minutes!

---

## What's Included

✅ Responsive design (mobile, tablet, desktop)
✅ Professional styling with gradient header
✅ All your resume content (7+ years Kafka/data engineering experience)
✅ Contact links (email, LinkedIn, phone)
✅ Print-to-PDF friendly
✅ Fast loading, no dependencies

---

## Need Help?

If you encounter issues, check:
- GitHub status: https://www.githubstatus.com/
- GitHub Pages docs: https://docs.github.com/en/pages

Good luck with your job search! 🚀

