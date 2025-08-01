// Test script to debug SIC code filtering
// IMPORTANT: Replace YOUR_API_KEY_HERE with your actual API key from .env file

String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key from .env file

try {
    System.debug('=== Testing SIC Code Filtering ===');
    
    if (apiKey == 'YOUR_API_KEY_HERE') {
        System.debug('ERROR: Please replace YOUR_API_KEY_HERE with your actual API key');
        return;
    }

    
    // Test with a specific SIC code
    String testSicCode = '62012'; // Business and domestic software development
    String testStatus = 'active';
    
    System.debug('Testing SIC Code: ' + testSicCode);
    System.debug('Testing Status: ' + testStatus);
    
    List<CompaniesHouse.Company> companies = CompaniesHouseController.getCompaniesBySICAndStatus(testSicCode, testStatus, apiKey);
    
    String companyCount = companies != null ? String.valueOf(companies.size()) : 'null';
    System.debug('Number of companies returned: ' + companyCount);
    
    if (companies != null && companies.size() > 0) {
        System.debug('SUCCESS: Found ' + companies.size() + ' companies');
        System.debug('First company: ' + companies[0].company_name);
    } else {
        System.debug('No companies found for SIC code: ' + testSicCode);
    }
    
} catch (Exception e) {
    System.debug('ERROR in SIC filtering: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
} 