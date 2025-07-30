#!/bin/bash

# Setup script for Companies House Salesforce Integration with master branch
# This script helps you set up the repository with the master branch

echo "🚀 Companies House Salesforce Integration - Master Branch Setup"
echo "=============================================================="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

echo "✅ Git is installed"

# Get repository URL from user
read -p "Enter your GitHub repository URL (e.g., https://github.com/username/repo-name): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ Repository URL is required"
    exit 1
fi

# Extract repository name from URL
REPO_NAME=$(basename "$REPO_URL" .git)
echo "📦 Repository name: $REPO_NAME"

# Clone the repository
echo "📥 Cloning repository..."
git clone "$REPO_URL" temp-repo
cd temp-repo

# Check if master branch exists
if git show-ref --verify --quiet refs/remotes/origin/master; then
    echo "✅ Master branch exists"
    git checkout master
else
    echo "⚠️  Master branch doesn't exist, creating it..."
    git checkout -b master
fi

# Copy files from the current directory
echo "📁 Copying files..."
cp -r ../* .

# Add all files
git add .

# Commit the changes
echo "💾 Committing changes..."
git commit -m "Initial commit: Companies House Salesforce Integration

- Added CompaniesHouseController with configurable API key
- Added SICCodeHelper for filtering utilities
- Added recentCompaniesViewer and companyCard LWC components
- Added Remote Site Settings for API access
- Added comprehensive documentation and deployment scripts
- Configured for master branch deployment"

# Push to master branch
echo "🚀 Pushing to master branch..."
git push origin master

# Clean up
cd ..
rm -rf temp-repo

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Go to your GitHub repository: $REPO_URL"
echo "2. Verify that 'master' is the default branch"
echo "3. Check that all files are present"
echo "4. Configure GitHub secrets for automated deployment (optional)"
echo "5. Follow the README.md for deployment instructions"
echo ""
echo "📖 For detailed setup instructions, see BRANCH_SETUP.md" 