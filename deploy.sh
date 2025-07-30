#!/bin/bash

# Companies House Salesforce Integration - Deployment Script
# This script deploys the Companies House integration to your Salesforce org

echo "🚀 Companies House Salesforce Integration - Deployment Script"
echo "=========================================================="

# Check if Salesforce CLI is installed
if ! command -v sf &> /dev/null; then
    echo "❌ Salesforce CLI is not installed. Please install it first:"
    echo "   https://developer.salesforce.com/tools/sfdxcli"
    exit 1
fi

# Check if user is authenticated
if ! sf org list &> /dev/null; then
    echo "❌ You are not authenticated with Salesforce CLI."
    echo "   Please run: sf org login web"
    exit 1
fi

echo "✅ Salesforce CLI is installed and authenticated"

# Deploy the package
echo "📦 Deploying Companies House integration..."
sf project deploy start --source-dir force-app/main/default --manifest companies-house-package.xml

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🎉 Next steps:"
    echo "1. Get your Companies House API key from: https://developer.company-information.service.gov.uk/"
    echo "2. Add the recentCompaniesViewer component to a Lightning page"
    echo "3. Set the apiKey attribute to your API key"
    echo "4. Save and activate the page"
    echo ""
    echo "📖 For detailed instructions, see the README.md file"
else
    echo "❌ Deployment failed. Please check the error messages above."
    exit 1
fi 