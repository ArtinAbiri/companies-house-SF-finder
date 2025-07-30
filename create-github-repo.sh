#!/bin/bash

echo "🚀 Creating GitHub Repository for Companies House Salesforce Integration"
echo "===================================================================="

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found"
    
    # Check if user is authenticated
    if gh auth status &> /dev/null; then
        echo "✅ GitHub CLI authenticated"
        
        # Create repository
        echo "📦 Creating GitHub repository..."
        gh repo create companies-house-salesforce \
            --public \
            --description "Salesforce Lightning Web Component for UK Companies House API integration" \
            --source=. \
            --remote=origin \
            --push
        
        if [ $? -eq 0 ]; then
            echo "✅ Repository created and pushed successfully!"
            echo "🔗 Repository URL: https://github.com/$(gh api user --jq .login)/companies-house-salesforce"
        else
            echo "❌ Failed to create repository"
        fi
    else
        echo "❌ GitHub CLI not authenticated. Please run: gh auth login"
        exit 1
    fi
else
    echo "❌ GitHub CLI not found. Please install it first:"
    echo "   https://cli.github.com/"
    echo ""
    echo "📋 Manual setup instructions:"
    echo "1. Go to https://github.com/new"
    echo "2. Create repository named 'companies-house-salesforce'"
    echo "3. Don't initialize with README, .gitignore, or license"
    echo "4. Set master as default branch"
    echo "5. Copy the repository URL"
    echo "6. Run: git remote add origin <repository-url>"
    echo "7. Run: git push -u origin master"
fi 