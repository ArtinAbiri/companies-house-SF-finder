// Test script to verify improved company search
// This will clear cache and test the new search functionality

// Clear the cache first
CompaniesHouseController.clearCache();

// Test the improved getRecentCompanies method
// Note: You'll need to replace 'YOUR_API_KEY' with your actual API key
String apiKey = 'YOUR_API_KEY'; // Replace with your actual API key

try {
    List<CompaniesHouse.Company> companies = CompaniesHouseController.getRecentCompanies(apiKey);
    
    System.debug('Found ' + companies.size() + ' companies');
    
    // Display the first 10 companies to verify variety
    for (Integer i = 0; i < Math.min(10, companies.size()); i++) {
        CompaniesHouse.Company company = companies[i];
        System.debug('Company ' + (i+1) + ': ' + company.company_name + ' (' + company.company_number + ') - Status: ' + company.company_status);
    }
    
    // Check for variety in company names
    Set<String> namePrefixes = new Set<String>();
    for (CompaniesHouse.Company company : companies) {
        if (company.company_name != null && company.company_name.length() > 0) {
            namePrefixes.add(company.company_name.substring(0, 1).toUpperCase());
        }
    }
    
    System.debug('Company names start with letters: ' + namePrefixes);
    System.debug('Variety score: ' + namePrefixes.size() + ' different starting letters out of ' + companies.size() + ' companies');
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
} 