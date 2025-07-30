#!/bin/bash

echo "🚀 Quick Push to GitHub"
echo "======================"

echo "Please create a GitHub repository first:"
echo "1. Go to https://github.com/new"
echo "2. Name it 'companies-house-salesforce'"
echo "3. Make it public"
echo "4. Don't initialize with README, .gitignore, or license"
echo "5. Set master as default branch"
echo ""
read -p "Enter your GitHub repository URL (e.g., https://github.com/username/companies-house-salesforce.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ Repository URL is required"
    exit 1
fi

echo "📦 Adding remote origin..."
git remote add origin "$REPO_URL"

echo "🚀 Pushing to GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed to GitHub!"
    echo "🔗 Repository URL: $REPO_URL"
    echo ""
    echo "🎉 Your Companies House Salesforce integration is now live on GitHub!"
    echo "📖 Users can now clone and deploy it using the instructions in README.md"
else
    echo "❌ Failed to push to GitHub. Please check your credentials and try again."
fi 