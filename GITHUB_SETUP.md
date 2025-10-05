# GitHub Setup Guide

This guide will help you upload AdMetrics to GitHub.

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and log in
2. Click the "+" icon → "New repository"
3. Fill in the details:
   - **Repository name:** `AdMetrics`
   - **Description:** `Beautiful macOS app and widgets to monitor your Google AdSense earnings in real-time`
   - **Visibility:** Public or Private (your choice)
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
4. Click "Create repository"

## Step 2: Configure Git (First Time Only)

If you haven't configured Git before:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 3: Push to GitHub

Replace `YOUR_USERNAME` with your actual GitHub username:

```bash
cd ~/Documents/AdMetrics

# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/AdMetrics.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Update README

After pushing, update the README.md file on GitHub to replace `YOUR_USERNAME` with your actual username in all URLs.

Or update locally and push:

```bash
# Replace YOUR_USERNAME in README.md and install.sh with your actual username
sed -i '' 's/YOUR_USERNAME/your-actual-username/g' README.md
sed -i '' 's/YOUR_USERNAME/your-actual-username/g' install.sh

# Commit and push
git add README.md install.sh
git commit -m "Update repository URLs with actual username"
git push
```

## Step 5: Create Release (Optional but Recommended)

1. Go to your repository on GitHub
2. Click "Releases" → "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `AdMetrics v1.0.0 - Initial Release`
5. Description:
   ```
   ## 🎉 First Release of AdMetrics!
   
   Beautiful macOS app and widgets for monitoring Google AdSense earnings.
   
   ### Features
   - 3 beautiful widget sizes with vibrant blue gradient design
   - Real-time balance and earnings display
   - 7-day revenue sparkline
   - Secure OAuth 2.0 authentication
   - Premium glass morphism design
   
   ### Installation
   Run the one-click installer:
   ```bash
   curl -O https://raw.githubusercontent.com/YOUR_USERNAME/AdMetrics/main/install.sh
   chmod +x install.sh
   ./install.sh
   ```
   
   ### Requirements
   - macOS 14.0+ (Sonoma or later)
   - Active Google AdSense account
   ```
6. Upload built app (optional):
   - Build: `xcodebuild -scheme AdMetrics -configuration Release`
   - Zip: `cd build/Build/Products/Release && zip -r AdMetrics.app.zip AdMetrics.app`
   - Upload the zip file
7. Click "Publish release"

## Step 6: Add Topics (Tags)

On your repository page:
1. Click the gear icon next to "About"
2. Add topics: `macos`, `swift`, `swiftui`, `widgetkit`, `adsense`, `widgets`, `macos-app`
3. Save changes

## Step 7: Enable GitHub Pages (Optional)

For documentation website:
1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: main, folder: / (root)
4. Save

## Useful Git Commands

### Daily workflow:
```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Description of changes"

# Push to GitHub
git push

# Pull latest changes
git pull
```

### Creating new features:
```bash
# Create feature branch
git checkout -b feature/new-feature

# Work on feature...

# Push feature branch
git push -u origin feature/new-feature

# Merge to main (on GitHub via Pull Request)
```

## Your Repository is Now Ready! 🎉

Users can now install AdMetrics with:

```bash
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/AdMetrics/main/install.sh
chmod +x install.sh
./install.sh
```

## Next Steps

1. ⭐ Ask users to star your repository
2. 📝 Add screenshots to README
3. 🐛 Monitor issues and respond to users
4. 🔄 Keep updating and improving
5. 📢 Share on social media and Reddit (r/macapps)

## Need Help?

- GitHub Guides: https://guides.github.com/
- Git Documentation: https://git-scm.com/doc
