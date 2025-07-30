# Example Usage

This document shows how to use the Companies House integration component in different scenarios.

## Basic Usage

### Simple Implementation

```html
<!-- Add to any Lightning page -->
<c-recent-companies-viewer 
    api-key="your-api-key-here">
</c-recent-companies-viewer>
```

### With Custom Configuration

```html
<c-recent-companies-viewer 
    api-key="your-api-key-here"
    banner-text="Find Your Next Business Partner"
    items-per-page="8">
</c-recent-companies-viewer>
```

## Use Case Examples

### 1. Sales Team Dashboard

Create a dashboard for your sales team to research prospects:

```html
<!-- Sales Dashboard Page -->
<lightning-card title="Prospect Research">
    <div class="slds-p-around_medium">
        <c-recent-companies-viewer 
            api-key="your-api-key-here"
            banner-text="Discover New Sales Opportunities"
            items-per-page="10">
        </c-recent-companies-viewer>
    </div>
</lightning-card>
```

### 2. Business Development Page

Create a dedicated page for business development activities:

```html
<!-- Business Development Page -->
<lightning-card title="Market Research">
    <div class="slds-p-around_medium">
        <c-recent-companies-viewer 
            api-key="your-api-key-here"
            banner-text="Market Intelligence Dashboard"
            items-per-page="12">
        </c-recent-companies-viewer>
    </div>
</lightning-card>
```

### 3. Lead Generation Tool

Create a lead generation tool for your marketing team:

```html
<!-- Lead Generation Page -->
<lightning-card title="Lead Generation">
    <div class="slds-p-around_medium">
        <c-recent-companies-viewer 
            api-key="your-api-key-here"
            banner-text="Generate Quality Leads"
            items-per-page="6">
        </c-recent-companies-viewer>
    </div>
</lightning-card>
```

### 4. Compliance Verification

Create a compliance verification tool:

```html
<!-- Compliance Page -->
<lightning-card title="Company Verification">
    <div class="slds-p-around_medium">
        <c-recent-companies-viewer 
            api-key="your-api-key-here"
            banner-text="Verify Company Information"
            items-per-page="4">
        </c-recent-companies-viewer>
    </div>
</lightning-card>
```

## Integration with Other Components

### With Lightning Data Table

```html
<lightning-card title="Company Analysis">
    <div class="slds-grid slds-wrap">
        <div class="slds-col slds-size_1-of-2">
            <c-recent-companies-viewer 
                api-key="your-api-key-here"
                banner-text="Company Discovery">
            </c-recent-companies-viewer>
        </div>
        <div class="slds-col slds-size_1-of-2">
            <lightning-datatable
                data={selectedCompanies}
                columns={columns}
                key-field="company_number">
            </lightning-datatable>
        </div>
    </div>
</lightning-card>
```

### With Custom Filters

```html
<lightning-card title="Advanced Company Search">
    <div class="slds-p-around_medium">
        <!-- Custom filters can be added here -->
        <div class="slds-m-bottom_medium">
            <lightning-combobox
                label="Industry Focus"
                options={industryOptions}
                onchange={handleIndustryChange}>
            </lightning-combobox>
        </div>
        
        <c-recent-companies-viewer 
            api-key="your-api-key-here"
            banner-text="Advanced Company Search"
            items-per-page="8">
        </c-recent-companies-viewer>
    </div>
</lightning-card>
```

## Best Practices

### 1. API Key Management

Never hardcode your API key in the component. Instead:

1. **Use Custom Settings** (Recommended):
   ```apex
   // In your Apex controller
   Companies_House_Config__c config = Companies_House_Config__c.getInstance();
   String apiKey = config.API_Key__c;
   ```

2. **Use Named Credentials**:
   - Create a Named Credential for Companies House API
   - Store the API key securely in the Named Credential

3. **Use Environment Variables**:
   - Store API key in environment variables
   - Access via Apex using `System.getEnvironmentVariable()`

### 2. Performance Optimization

```html
<!-- Use caching for better performance -->
<c-recent-companies-viewer 
    api-key="your-api-key-here"
    items-per-page="6">
</c-recent-companies-viewer>
```

### 3. Error Handling

```html
<!-- Add error handling -->
<template if:true={hasError}>
    <lightning-card title="Error">
        <div class="slds-text-color_error">
            Unable to load company data. Please try again later.
        </div>
    </lightning-card>
</template>

<template if:false={hasError}>
    <c-recent-companies-viewer 
        api-key="your-api-key-here">
    </c-recent-companies-viewer>
</template>
```

## Customization Examples

### Custom Styling

```css
/* Add to your component's CSS */
:host {
    --primary-color: #0176d3;
    --secondary-color: #1ab394;
    --background-color: #ffffff;
    --border-radius: 8px;
    --box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

### Custom Banner

```html
<!-- Custom banner with your branding -->
<div class="custom-banner slds-m-bottom_medium">
    <img src={yourLogo} alt="Your Company Logo" />
    <h2>Your Custom Banner Text</h2>
</div>

<c-recent-companies-viewer 
    api-key="your-api-key-here"
    banner-text="">
</c-recent-companies-viewer>
```

## Troubleshooting Examples

### Debug Mode

```html
<!-- Add debug information -->
<template if:true={showDebug}>
    <lightning-card title="Debug Information">
        <div class="slds-p-around_medium">
            <p>API Key: {maskedApiKey}</p>
            <p>Companies Loaded: {companyCount}</p>
            <p>Last Updated: {lastUpdated}</p>
        </div>
    </lightning-card>
</template>
```

### Loading States

```html
<!-- Show loading state -->
<template if:true={isLoading}>
    <lightning-spinner alternative-text="Loading companies...">
    </lightning-spinner>
</template>

<template if:false={isLoading}>
    <c-recent-companies-viewer 
        api-key="your-api-key-here">
    </c-recent-companies-viewer>
</template>
```

## Security Considerations

### API Key Security

1. **Never expose API keys in client-side code**
2. **Use server-side storage for API keys**
3. **Implement proper access controls**
4. **Monitor API usage and set rate limits**

### Data Privacy

1. **Only display publicly available company information**
2. **Respect data protection regulations**
3. **Implement proper data retention policies**
4. **Log access for audit purposes**

## Performance Tips

1. **Use appropriate page sizes** (6-12 items per page)
2. **Enable caching** (already built into the component)
3. **Monitor API call limits**
4. **Implement proper error handling**
5. **Use filters to reduce unnecessary API calls**

## Integration Checklist

- [ ] API key is securely stored
- [ ] Remote Site Settings are configured
- [ ] Component is added to Lightning page
- [ ] Error handling is implemented
- [ ] Performance is optimized
- [ ] Security measures are in place
- [ ] Testing is completed
- [ ] Documentation is updated 