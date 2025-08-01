// Comprehensive test to debug filtering issues
// IMPORTANT: Replace YOUR_API_KEY_HERE with your actual API key from .env file

String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key from .env file

try {
    System.debug('=== Comprehensive Filtering Debug Test ===');
    

    
    // Test 1: Basic API connectivity
    System.debug('\n--- Test 1: Basic API Connectivity ---');
    List<CompaniesHouse.Company> recentCompanies = CompaniesHouseController.getRecentCompanies(apiKey);
    String recentCount = recentCompanies != null ? String.valueOf(recentCompanies.size()) : 'null';
    System.debug('Recent companies count: ' + recentCount);
    
    // Test 2: SIC Code filtering
    System.debug('\n--- Test 2: SIC Code Filtering ---');
    String testSicCode = '62012'; // Business and domestic software development
    List<CompaniesHouse.Company> sicCompanies = CompaniesHouseController.getCompaniesBySICAndStatus(testSicCode, '', apiKey);
    String sicCount = sicCompanies != null ? String.valueOf(sicCompanies.size()) : 'null';
    System.debug('SIC ' + testSicCode + ' companies count: ' + sicCount);
    
    if (sicCompanies != null && sicCompanies.size() > 0) {
        System.debug('First SIC company: ' + sicCompanies[0].company_name);
        System.debug('First SIC company status: ' + sicCompanies[0].company_status);
    }
    
    // Test 3: Status filtering
    System.debug('\n--- Test 3: Status Filtering ---');
    String testStatus = 'active';
    List<CompaniesHouse.Company> statusCompanies = CompaniesHouseController.getCompaniesBySICAndStatus('', testStatus, apiKey);
    String statusCount = statusCompanies != null ? String.valueOf(statusCompanies.size()) : 'null';
    System.debug('Status ' + testStatus + ' companies count: ' + statusCount);
    
    if (statusCompanies != null && statusCompanies.size() > 0) {
        System.debug('First status company: ' + statusCompanies[0].company_name);
        System.debug('First status company status: ' + statusCompanies[0].company_status);
    }
    
    // Test 4: Combined SIC + Status filtering
    System.debug('\n--- Test 4: Combined SIC + Status Filtering ---');
    List<CompaniesHouse.Company> combinedCompanies = CompaniesHouseController.getCompaniesBySICAndStatus(testSicCode, testStatus, apiKey);
    String combinedCount = combinedCompanies != null ? String.valueOf(combinedCompanies.size()) : 'null';
    System.debug('SIC ' + testSicCode + ' + Status ' + testStatus + ' companies count: ' + combinedCount);
    
    if (combinedCompanies != null && combinedCompanies.size() > 0) {
        System.debug('First combined company: ' + combinedCompanies[0].company_name);
        System.debug('First combined company status: ' + combinedCompanies[0].company_status);
    }
    
    // Test 5: SIC Code options loading
    System.debug('\n--- Test 5: SIC Code Options ---');
    List<SICCodeHelper.SICCodeOption> sicOptions = SICCodeHelper.getSICCodeOptions();
    String sicOptionsCount = sicOptions != null ? String.valueOf(sicOptions.size()) : 'null';
    System.debug('SIC options count: ' + sicOptionsCount);
    
    if (sicOptions != null && sicOptions.size() > 0) {
        System.debug('First SIC option: ' + sicOptions[0].code + ' - ' + sicOptions[0].description);
    }
    
    // Test 6: Company Status options loading
    System.debug('\n--- Test 6: Company Status Options ---');
    List<SICCodeHelper.CompanyStatusOption> statusOptions = SICCodeHelper.getCompanyStatusOptions();
    String statusOptionsCount = statusOptions != null ? String.valueOf(statusOptions.size()) : 'null';
    System.debug('Status options count: ' + statusOptionsCount);
    
    if (statusOptions != null && statusOptions.size() > 0) {
        System.debug('First status option: ' + statusOptions[0].value + ' - ' + statusOptions[0].label);
    }
    
    System.debug('\n=== Test Complete ===');
    
} catch (Exception e) {
    System.debug('ERROR in filtering test: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}