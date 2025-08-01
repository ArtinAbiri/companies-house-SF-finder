# Companies House Salesforce Component

A Lightning Web Component for Salesforce that integrates with the UK Companies House API to search, display, and create records from company data.

![Companies House Component](https://img.shields.io/badge/Salesforce-Lightning%20Web%20Component-blue)
![API Version](https://img.shields.io/badge/API%20Version-62.0-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## 🚀 Features

- **Real-time Company Search**: Search UK companies using the Companies House API
- **Advanced Filtering**: Filter by SIC codes, company status, and incorporation dates
- **Lead/Account Creation**: Convert company data into Salesforce Leads or Accounts
- **Responsive Design**: Mobile-friendly interface with modern styling
- **Caching**: Built-in caching for improved performance
- **Error Handling**: Robust error handling and user feedback

## 📋 Prerequisites

- Salesforce org with Lightning Experience enabled
- Companies House API key (free from [Companies House Developer Hub](https://developer.company-information.service.gov.uk/))
- System Administrator access to deploy components

## 🛠️ Installation

### Option 1: Standard Deployment (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ArtinAbiri/companies-house-SF-finder.git
   cd companies-house-SF-finder
   ```

2. **Deploy to your Salesforce org**:
   ```bash
   sf project deploy start --source-dir force-app/main/default --target-org your-org-alias
   ```

### Option 2: Package Deployment

1. **Deploy using package.xml**:
   ```bash
   sf project deploy start --manifest companies-house-package.xml --target-org your-org-alias
   ```

## ⚙️ Configuration

### 1. Set up Remote Site Settings

The deployment includes the required Remote Site Setting, but verify it's configured:

- **Name**: `Companies_House_API`
- **Remote Site URL**: `https://api.company-information.service.gov.uk`
- **Active**: ✅ Checked

### 2. Get your API Key

1. Visit [Companies House Developer Hub](https://developer.company-information.service.gov.uk/)
2. Create a free account
3. Generate an API key
4. Keep this key secure - you'll need it when using the component

### 3. Add Component to Lightning Pages

1. Go to **Setup** → **Lightning App Builder**
2. Edit or create a Lightning page
3. Drag the **"Companies House"** component onto the page
4. Configure the component properties:
   - **API Key**: Your Companies House API key
   - **Banner Text**: Custom text (optional)
   - **Items Per Page**: Number of companies to display (default: 6)

## 🎯 Usage

### Basic Search
1. Enter a company name or number in the search field
2. Click **Search** to find companies
3. Use filters to narrow results by:
   - SIC codes (business activities)
   - Company status (active, dissolved, etc.)
   - Incorporation date range

### Creating Records
1. Find a company in the search results
2. Click **Create Lead** or **Create Account**
3. The component will create a Salesforce record with:
   - Company information
   - Registered address
   - Officer details (if available)
   - Custom fields (if they exist in your org)

## 🏗️ Architecture

### Components

- **`recentCompaniesViewer`**: Main component for searching and displaying companies
- **`companyCard`**: Child component for individual company display and record creation

### Apex Classes

- **`CompaniesHouseController`**: Main controller with API integration and record creation
- **`CompaniesHouse`**: Wrapper classes for API responses
- **`SICCodeHelper`**: Helper class for SIC code management and filtering

### Custom Fields (Optional)

The component can populate custom fields if they exist in your org:

**Lead/Account Fields:**
- `Company_Number__c` (Text)
- `Incorporation_Date__c` (Date)
- `First_Officer_Name__c` (Text)
- `First_Officer_Role__c` (Text)
- `First_Officer_Occupation__c` (Text)

**Contact Fields:**
- `Occupation__c` (Text)
- `Nationality__c` (Text)
- `Date_of_Birth__c` (Date)

## 🔧 Customization

### Styling
Modify the CSS files in the LWC components:
- `recentCompaniesViewer.css` - Main component styling
- `companyCard.css` - Individual company card styling

### API Configuration
Update constants in `CompaniesHouseController.cls`:
- `MAX_RESULTS` - Maximum companies to fetch
- `CACHE_DURATION_MINUTES` - Cache duration

### Field Mapping
Customize field mapping in the `createLeadFromCompany` and `createAccountFromCompany` methods.

## 📊 API Limits

- **Companies House API**: 600 requests per 5 minutes
- **Component Caching**: Reduces API calls through intelligent caching
- **Batch Processing**: Efficiently handles multiple API requests

## 🔒 Security

- API keys are handled securely through component properties
- All API calls use HTTPS
- Input validation prevents injection attacks
- Error messages don't expose sensitive information

## 🐛 Troubleshooting

### Common Issues

1. **"Remote site not configured"**
   - Verify Remote Site Settings are properly configured
   - Check the URL matches exactly: `https://api.company-information.service.gov.uk`

2. **"Invalid API key"**
   - Verify your API key is correct
   - Ensure the key is active in your Companies House account

3. **"No companies found"**
   - Try broader search terms
   - Check if the company exists in Companies House database
   - Verify API key permissions

### Debug Steps

1. Check browser console for JavaScript errors
2. Review Salesforce debug logs for Apex errors
3. Verify component properties are set correctly
4. Test API key independently using Companies House API documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m 'Add your feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Companies House](https://www.gov.uk/government/organisations/companies-house) for providing the API
- Salesforce Developer Community for Lightning Web Component resources
- Contributors and testers who helped improve this component

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/ArtinAbiri/companies-house-SF-finder/issues)
- **Documentation**: [Companies House API Docs](https://developer.company-information.service.gov.uk/api/docs/)
- **Salesforce**: [Lightning Web Components Developer Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)

---

**Made with ❤️ for the Salesforce community**