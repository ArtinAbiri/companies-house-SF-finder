// Simple test for filtering functionality
// IMPORTANT: Replace YOUR_API_KEY_HERE with your actual API key from .env file

String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key from .env file

try {
    System.debug('=== Simple Filtering Test ===');
    
    // Test 1: Status filtering only
    System.debug('\n--- Test 1: Status Filtering Only ---');
    List<CompaniesHouse.Company> statusCompanies = CompaniesHouseController.getCompaniesBySICAndStatus('', 'active', apiKey);
    String statusCount = statusCompanies != null ? String.valueOf(statusCompanies.size()) : 'null';
    System.debug('Status "active" companies count: ' + statusCount);
    
    if (statusCompanies != null && statusCompanies.size() > 0) {
        System.debug('First status company: ' + statusCompanies[0].company_name);
        System.debug('First status company status: ' + statusCompanies[0].company_status);
    }
    
    // Test 2: SIC filtering only (limited to avoid callout limits)
    System.debug('\n--- Test 2: SIC Filtering Only ---');
    List<CompaniesHouse.Company> sicCompanies = CompaniesHouseController.getCompaniesBySICAndStatus('62012', '', apiKey);
    String sicCount = sicCompanies != null ? String.valueOf(sicCompanies.size()) : 'null';
    System.debug('SIC "62012" companies count: ' + sicCount);
    
    if (sicCompanies != null && sicCompanies.size() > 0) {
        System.debug('First SIC company: ' + sicCompanies[0].company_name);
        System.debug('First SIC company status: ' + sicCompanies[0].company_status);
    }
    
    System.debug('\n=== Test Complete ===');
    
} catch (Exception e) {
    System.debug('ERROR in filtering test: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}