# Companies House Integration for Salesforce

A Lightning Web Component (LWC) package that integrates with the UK Companies House Public Data API to display and search for company information directly within Salesforce.

## 🚀 Features

- **Real-time Company Data**: Fetch live company information from Companies House API
- **Advanced Filtering**: Filter companies by SIC codes (industry) and company status
- **Search Functionality**: Search companies by name with instant results
- **Officer Information**: Display first officer details for each company
- **Beautiful UI**: Modern, responsive design with smooth animations
- **Intelligent Caching**: 5-minute cache to improve performance and reduce API calls
- **Pagination**: Navigate through large result sets efficiently
- **Mobile Responsive**: Works seamlessly on desktop and mobile devices

## 📋 Use Cases

This component is perfect for:
- **Sales Teams**: Research potential prospects and their company details
- **Business Development**: Identify new companies in specific industries
- **Lead Generation**: Find recently incorporated companies for outreach
- **Market Research**: Analyze company trends and industry data
- **Compliance Teams**: Verify company information and officer details

## 🛠️ Prerequisites

- Salesforce org with API access
- Companies House API key (free from https://developer.company-information.service.gov.uk/)
- Salesforce CLI (for deployment)

## 📦 Package Contents

### Apex Classes
- `CompaniesHouseController` - Main API integration and business logic
- `SICCodeHelper` - SIC code management and filtering utilities

### Lightning Web Components
- `recentCompaniesViewer` - Main component for displaying and filtering companies
- `companyCard` - Individual company card component with detailed information

### Remote Site Settings
- `Companies_House_API` - Allows callouts to Companies House API

### Static Resources
- `companiesHouseBanner` - Companies House branding image

## 🚀 Quick Start

### Step 1: Get Your API Key

1. Visit https://developer.company-information.service.gov.uk/
2. Sign up for a free account
3. Generate an API key
4. Note down your API key for the next steps

### Step 2: Deploy to Your Org

#### Option A: Using Salesforce CLI (Recommended)

```bash
# Clone this repository
git clone https://github.com/your-username/companies-house-salesforce.git
cd companies-house-salesforce

# Switch to master branch (if not already on it)
git checkout master

# Deploy the package
sf project deploy start --source-dir force-app/main/default --manifest companies-house-package.xml
```

#### Option B: Using Metadata API

1. Download the `force-app` folder
2. Deploy via your preferred Salesforce deployment tool
3. Ensure all components are deployed successfully

### Step 3: Configure the Component

1. **Add to a Lightning Page:**
   - Go to Setup → Lightning App Builder
   - Create a new Lightning Page or edit an existing one
   - Add the `Companies House` component
   - Set the `apiKey` attribute to your Companies House API key
   - Save and activate the page

2. **Or Add to an Existing Page:**
   - Edit any Lightning page
   - Add the `Companies House` component
   - Configure the `apiKey` attribute
   - Save the page

### Step 4: Verify Remote Site Settings

The package includes a Remote Site Setting, but verify it's active:

1. Go to Setup → Security → Remote Site Settings
2. Find `Companies_House_API`
3. Ensure it's active and the URL is: `https://api.company-information.service.gov.uk`

## 🔧 Configuration

### Component Attributes

The `Companies House` component accepts the following attributes:

- `apiKey` (Required): Your Companies House API key
- `bannerText` (Optional): Custom banner text (default: "Discover the latest companies registered with Companies House")
- `itemsPerPage` (Optional): Number of companies per page (default: 6)

### Example Usage

```html
<c-recent-companies-viewer 
    api-key="your-api-key-here"
    banner-text="Find Your Next Business Partner"
    items-per-page="8">
</c-recent-companies-viewer>
```

## 📊 How to Use

### Basic Usage
The component automatically loads recent companies when the page loads.

### Filtering Companies

1. **By Industry (SIC Code):**
   - Click the "Industry (SIC Code)" dropdown
   - Search for your desired SIC code
   - Select the code to filter companies

2. **By Company Status:**
   - Click the "Company Status" dropdown
   - Select one or more statuses (Active, Registered, etc.)
   - Apply filters to see results

3. **Combined Filters:**
   - Use both SIC code and status filters together
   - Click "Apply Filters" to see combined results

### Searching Companies
1. Enter a company name in the search box
2. Click "Search" to find matching companies
3. Use "Clear" to reset the search

### Navigation
- Use pagination controls to navigate through results
- Click "Refresh" to clear cache and reload data
- Use "Clear Filters" to reset all filters

## 🔍 API Endpoints Used

The component uses the following Companies House API endpoints:

- `GET /search/companies` - Basic company search
- `GET /company/{company_number}/officers` - Company officers
- `GET /company/{company_number}` - Company details

## 🎨 Customization

### Styling
The component uses CSS custom properties that can be overridden:

```css
/* Custom colors */
:host {
    --primary-color: #0176d3;
    --secondary-color: #1ab394;
    --background-color: #ffffff;
}
```

### Component Attributes
- `bannerText` - Custom banner text
- `itemsPerPage` - Number of companies per page
- `showPagination` - Show/hide pagination controls

## 🚨 Troubleshooting

### Common Issues

1. **"Too many callouts" error:**
   - The component limits results to 20 companies to stay within Salesforce limits
   - This is by design to prevent governor limit issues

2. **No companies found:**
   - Check your API key is correct
   - Verify the Remote Site Setting is active
   - Check the debug logs for API errors

3. **Component not loading:**
   - Ensure all components are deployed
   - Check for JavaScript errors in browser console
   - Verify the component is added to a Lightning page

### Debug Information
The component includes extensive debug logging:
- Check Setup → Debug → Debug Logs
- Look for `CompaniesHouseController` debug messages
- API requests and responses are logged

## 📋 Requirements

### Salesforce Requirements
- API Enabled permission
- Lightning Component Framework
- Remote Site Settings access

### API Requirements
- Companies House API key (free)
- Internet access from Salesforce org

## 🔒 Security

### Data Handling
- Company data is cached for 5 minutes to improve performance
- No sensitive data is stored permanently
- API calls are made securely via HTTPS

### Permissions
- The component requires no special user permissions
- API calls are made in system context
- Users only see the component UI

## 📈 Performance

### Optimization Features
- **Intelligent Caching**: 5-minute cache for API responses
- **Limited Results**: Maximum 20 companies to prevent callout limits
- **Lazy Loading**: Officers are fetched only when needed
- **Pagination**: Large result sets are paginated

### Best Practices
- Use filters to reduce API calls
- Clear cache periodically for fresh data
- Monitor debug logs for performance issues

## 🤝 Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔄 Version History

### Version 1.0.0
- Initial release
- Basic company search and display
- SIC code and status filtering
- Officer information display
- Responsive design with animations
- Caching and performance optimization

## 📞 Support

### Getting Help
1. Check the debug logs for error messages
2. Verify your API key is working
3. Test the Companies House API directly
4. Review the component documentation

### Issues
If you encounter any issues:
1. Check the troubleshooting section above
2. Search existing issues on GitHub
3. Create a new issue with detailed information

---

**Note**: This package requires a valid Companies House API key to function. The API key is free and can be obtained from the Companies House developer portal.

**Important**: Never commit your API key to version control. Always use the component's `apiKey` attribute to pass the key securely. 