# Testing the Companies House Integration

This guide helps you verify that the Companies House integration is working correctly after deployment.

## Pre-Test Checklist

- [ ] Package deployed successfully
- [ ] Remote Site Setting is active
- [ ] You have a valid Companies House API key
- [ ] Component added to a Lightning page

## Test Steps

### 1. Verify Remote Site Settings

1. Go to Setup → Security → Remote Site Settings
2. Find `Companies_House_API`
3. Ensure it's active
4. Verify URL is: `https://api.company-information.service.gov.uk`

### 2. Test Component Loading

1. Navigate to the Lightning page with the component
2. Check that the component loads without errors
3. Verify the banner image displays correctly
4. Check that the loading spinner appears briefly

### 3. Test API Connection

1. Open browser developer tools (F12)
2. Go to the Network tab
3. Refresh the page
4. Look for API calls to `api.company-information.service.gov.uk`
5. Verify responses are successful (200 status codes)

### 4. Test Company Display

1. Wait for companies to load
2. Verify company cards display with:
   - Company name
   - Company number
   - Incorporation date
   - Company status
   - Address information (if available)

### 5. Test Search Functionality

1. Enter a company name in the search box
2. Click "Search"
3. Verify results appear
4. Test "Clear" button to reset search

### 6. Test Filtering

1. Click "Industry (SIC Code)" dropdown
2. Search for a SIC code (e.g., "62012" for Software Development)
3. Select a code and click "Apply Filters"
4. Verify filtered results appear

### 7. Test Company Status Filter

1. Click "Company Status" dropdown
2. Select "Active" status
3. Click "Apply Filters"
4. Verify only active companies are shown

### 8. Test Pagination

1. If you have more than 6 companies, pagination should appear
2. Click "Next" to go to next page
3. Click "Previous" to go back
4. Verify companies change between pages

### 9. Test Refresh Functionality

1. Click the "Refresh" button
2. Verify the cache is cleared
3. Verify new data loads

## Debug Information

If tests fail, check the debug logs:

1. Go to Setup → Debug → Debug Logs
2. Create a new debug log for your user
3. Reproduce the issue
4. Check the log for `CompaniesHouseController` messages

## Common Issues and Solutions

### Issue: "No companies found"
**Solution**: Check your API key is correct and the Remote Site Setting is active

### Issue: "Too many callouts" error
**Solution**: This is expected - the component limits results to stay within Salesforce limits

### Issue: Component not loading
**Solution**: Check browser console for JavaScript errors and verify all components are deployed

### Issue: API calls failing
**Solution**: Verify your internet connection and that the Companies House API is accessible

## Performance Testing

1. **Load Time**: Component should load within 5-10 seconds
2. **Search Response**: Search results should appear within 3-5 seconds
3. **Filter Response**: Filtered results should appear within 3-5 seconds
4. **Cache Performance**: Subsequent loads should be faster due to caching

## Success Criteria

The integration is working correctly if:

- [ ] Component loads without errors
- [ ] Companies display with correct information
- [ ] Search functionality works
- [ ] Filtering works for both SIC codes and status
- [ ] Pagination works correctly
- [ ] Refresh functionality works
- [ ] No console errors in browser
- [ ] API calls are successful in Network tab

If all criteria are met, your Companies House integration is ready for use! 