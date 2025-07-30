# GitHub Branch Setup Guide

This guide helps you set up the repository with the `master` branch as the default branch.

## 🎯 Branch Configuration

This repository is configured to use the `master` branch as the default branch, following traditional Git conventions.

## 📋 Setup Instructions

### 1. Create GitHub Repository

1. Go to GitHub and create a new repository
2. **Important**: Do NOT initialize with README, .gitignore, or license
3. Name your repository (e.g., `companies-house-salesforce`)

### 2. Set Master as Default Branch

1. Go to your repository settings
2. Navigate to "Branches" in the left sidebar
3. Under "Default branch", click the switch button
4. Select "master" from the dropdown
5. Click "Update"
6. Confirm the change

### 3. Upload the Code

```bash
# Clone the repository (it will be empty)
git clone https://github.com/your-username/companies-house-salesforce.git
cd companies-house-salesforce

# Copy all files from the companies-house-github folder
cp -r ../companies-house-github/* .

# Add all files to git
git add .

# Commit the changes
git commit -m "Initial commit: Companies House Salesforce Integration"

# Push to master branch
git push origin master
```

### 4. Verify Branch Setup

1. Go to your GitHub repository
2. Verify that `master` is the default branch
3. Check that all files are present
4. Verify the GitHub Actions workflow is configured for `master`

## 🔧 GitHub Actions Configuration

The repository includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) that:

- Triggers on pushes to the `master` branch
- Triggers on pull requests to the `master` branch
- Automatically deploys to Salesforce (if secrets are configured)

## 🔑 Required GitHub Secrets

For automated deployment, you'll need to set up these secrets in your GitHub repository:

1. Go to your repository settings
2. Navigate to "Secrets and variables" → "Actions"
3. Add the following secrets:
   - `SF_LOGIN_URL`: Your Salesforce login URL
   - `SF_USERNAME`: Your Salesforce username
   - `SF_PASSWORD`: Your Salesforce password
   - `SF_SECURITY_TOKEN`: Your Salesforce security token

## 📝 Branch Naming Convention

- **master**: Main development branch (default)
- **feature/***: Feature development branches
- **bugfix/***: Bug fix branches
- **hotfix/***: Hot fix branches

## 🚀 Deployment Workflow

### Manual Deployment
```bash
# Clone the repository
git clone https://github.com/your-username/companies-house-salesforce.git
cd companies-house-salesforce

# Ensure you're on master branch
git checkout master

# Deploy using the provided script
./deploy.sh
```

### Automated Deployment
1. Push changes to the `master` branch
2. GitHub Actions will automatically deploy to Salesforce
3. Check the Actions tab for deployment status

## 🔄 Contributing Workflow

1. **Fork the repository**
2. **Create a feature branch** from `master`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Commit and push**:
   ```bash
   git add .
   git commit -m "Add your feature description"
   git push origin feature/your-feature-name
   ```
5. **Create a pull request** to the `master` branch
6. **Review and merge** the pull request

## 📊 Branch Protection (Recommended)

Consider setting up branch protection for the `master` branch:

1. Go to repository settings → Branches
2. Add rule for `master` branch
3. Enable:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date
   - Include administrators

## 🎉 Success Criteria

Your repository is properly set up when:

- ✅ `master` is the default branch
- ✅ All files are present in the repository
- ✅ GitHub Actions workflow is configured
- ✅ Branch protection is enabled (optional)
- ✅ Deployment secrets are configured (for automated deployment)

## 📞 Troubleshooting

### Issue: Can't change default branch
**Solution**: Ensure you have admin access to the repository

### Issue: GitHub Actions not triggering
**Solution**: Check that the workflow file is in `.github/workflows/` and the branch name is correct

### Issue: Deployment fails
**Solution**: Verify all required secrets are configured in GitHub repository settings

---

**Ready for deployment with master branch!** 🚀 