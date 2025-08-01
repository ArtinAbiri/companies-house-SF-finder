// Test script to verify Companies House API is working
// IMPORTANT: Replace YOUR_API_KEY_HERE with your actual API key from .env file
// The API key should NEVER be committed to version control

String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key from .env file

try {
    System.debug('=== Testing Companies House API ===');
    System.debug('API Key: ' + (apiKey == 'YOUR_API_KEY_HERE' ? '[NOT SET]' : '[SET]'));
    
    if (apiKey == 'YOUR_API_KEY_HERE') {
        System.debug('ERROR: Please replace YOUR_API_KEY_HERE with your actual API key');
        return;
    }
    
    List<CompaniesHouse.Company> companies = CompaniesHouseController.getRecentCompanies(apiKey);
    
    String companyCount = companies != null ? String.valueOf(companies.size()) : 'null';
    System.debug('Number of companies returned: ' + companyCount);
    
    if (companies != null && companies.size() > 0) {
        System.debug('SUCCESS: Found ' + companies.size() + ' companies');
        System.debug('First company: ' + companies[0].company_name);
        System.debug('Company number: ' + companies[0].company_number);
        System.debug('Company status: ' + companies[0].company_status);
    } else {
        System.debug('ERROR: No companies returned or null response');
    }
    
} catch (Exception e) {
    System.debug('ERROR calling API: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
} 