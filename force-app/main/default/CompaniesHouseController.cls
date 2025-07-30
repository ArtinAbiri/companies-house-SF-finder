/**
 * @description Controller class for Companies House API integration
 * @author System
 * @date 2025-01-25
 */
public with sharing class CompaniesHouseController {
    
    // API configuration
    private static final String BASE_URL = 'https://api.company-information.service.gov.uk';
    private static final String SEARCH_ENDPOINT = '/search/companies';
    private static final String OFFICERS_ENDPOINT = '/company/';
    private static final Integer MAX_RESULTS = 30;
    
    // Cache for 5 minutes to improve performance
    private static Map<String, Object> cache = new Map<String, Object>();
    private static Map<String, DateTime> cacheTimestamps = new Map<String, DateTime>();
    private static final Integer CACHE_DURATION_MINUTES = 5;
    
    /**
     * @description Fetches the most recently incorporated companies from Companies House API
     * @param apiKey Companies House API key
     * @return List<CompaniesHouse.Company> List of recent companies
     */
    @AuraEnabled(cacheable=true)
    public static List<CompaniesHouse.Company> getRecentCompanies(String apiKey) {
        // Check cache first
        String cacheKey = 'recent_companies';
        if (cache.containsKey(cacheKey)) {
            DateTime cacheTime = cacheTimestamps.get(cacheKey);
            if (cacheTime != null && DateTime.now().getTime() - cacheTime.getTime() < CACHE_DURATION_MINUTES * 60 * 1000) {
                return (List<CompaniesHouse.Company>) cache.get(cacheKey);
            }
        }
        
        try {
            List<CompaniesHouse.Company> allCompanies = new List<CompaniesHouse.Company>();
            
            // Use simple text search queries as per API documentation
            List<String> searchQueries = new List<String>{
                'active',
                'registered',
                'incorporated 2025',
                'incorporated 2024'
            };
            
            for (String query : searchQueries) {
                String endpoint = BASE_URL + SEARCH_ENDPOINT + '?q=' + EncodingUtil.urlEncode(query, 'UTF-8') + '&items_per_page=100&start_index=0';
                
                System.debug('Search Query: ' + query);
                System.debug('Search Endpoint: ' + endpoint);
                
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endpoint);
                request.setMethod('GET');
                request.setHeader('Accept', 'application/json');
                request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':')));
                request.setTimeout(15000);
                
                Http http = new Http();
                HttpResponse response = http.send(request);
                
                System.debug('Response Status: ' + response.getStatusCode());
                System.debug('Response Body: ' + response.getBody());
                
                if (response.getStatusCode() == 200) {
                    String responseBody = response.getBody();
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                    List<Object> items = (List<Object>) jsonResponse.get('items');
                    
                    if (items != null) {
                        for (Object item : items) {
                            Map<String, Object> companyMap = (Map<String, Object>) item;
                            CompaniesHouse.Company company = mapToCompany(companyMap);
                            
                            // Only include companies with valid names and active status
                            if (String.isNotBlank(company.company_name) && 
                                String.isNotBlank(company.company_number) &&
                                (company.company_status == 'active' || company.company_status == 'registered')) {
                                
                                // Get the first officer for this company
                                company.first_officer = getFirstOfficer(company.company_number, apiKey);
                                
                                allCompanies.add(company);
                                
                                // Stop if we have enough companies
                                if (allCompanies.size() >= MAX_RESULTS) break;
                            }
                        }
                    }
                } else {
                    System.debug('Error for query ' + query + ': ' + response.getStatusCode() + ' - ' + response.getBody());
                }
                
                // Stop if we have enough companies
                if (allCompanies.size() >= MAX_RESULTS) break;
            }
            
            // Store in cache
            cache.put(cacheKey, allCompanies);
            cacheTimestamps.put(cacheKey, DateTime.now());
            
            return allCompanies;
            
        } catch (Exception e) {
            System.debug('Error in getRecentCompanies: ' + e.getMessage());
            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Fetches the first officer for a company
     * @param companyNumber Company number
     * @param apiKey Companies House API key
     * @return CompaniesHouse.Person First officer or null
     */
    private static CompaniesHouse.Person getFirstOfficer(String companyNumber, String apiKey) {
        try {
            String endpoint = BASE_URL + OFFICERS_ENDPOINT + companyNumber + '/officers?items_per_page=1&start_index=0';
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':')));
            request.setTimeout(15000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> items = (List<Object>) jsonResponse.get('items');
                
                if (items != null && !items.isEmpty()) {
                    Map<String, Object> officerMap = (Map<String, Object>) items[0];
                    return mapToPerson(officerMap);
                }
            }
            
        } catch (Exception e) {
            System.debug('Error getting first officer for company ' + companyNumber + ': ' + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * @description Searches companies by name
     * @param searchTerm Search term
     * @param apiKey Companies House API key
     * @return List<CompaniesHouse.Company> List of matching companies
     */
    @AuraEnabled(cacheable=true)
    public static List<CompaniesHouse.Company> searchCompanies(String searchTerm, String apiKey) {
        try {
            String endpoint = BASE_URL + SEARCH_ENDPOINT + '?q=' + EncodingUtil.urlEncode(searchTerm, 'UTF-8') + '&items_per_page=20&start_index=0';
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':')));
            request.setTimeout(15000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> items = (List<Object>) jsonResponse.get('items');
                
                List<CompaniesHouse.Company> companies = new List<CompaniesHouse.Company>();
                
                if (items != null) {
                    Integer count = 0;
                    for (Object item : items) {
                        Map<String, Object> companyMap = (Map<String, Object>) item;
                        CompaniesHouse.Company company = mapToCompany(companyMap);
                        
                        if (String.isNotBlank(company.company_name) && String.isNotBlank(company.company_number)) {
                            company.first_officer = getFirstOfficer(company.company_number, apiKey);
                            companies.add(company);
                            count++;
                            
                            // Limit to 20 companies to avoid callout limits
                            if (count >= 20) break;
                        }
                    }
                }
                
                return companies;
            } else {
                System.debug('Error response: ' + response.getBody());
                return new List<CompaniesHouse.Company>();
            }
            
        } catch (Exception e) {
            System.debug('Error in searchCompanies: ' + e.getMessage());
            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Gets companies by SIC code and status
     * @param sicCode SIC code to filter by
     * @param status Company status to filter by
     * @param apiKey Companies House API key
     * @return List<CompaniesHouse.Company> List of matching companies
     */
    @AuraEnabled(cacheable=true)
    public static List<CompaniesHouse.Company> getCompaniesBySICAndStatus(String sicCode, String status, String apiKey) {
        try {
            // Build search query
            String searchQuery = '';
            if (String.isNotBlank(sicCode)) {
                searchQuery += 'sic_codes:' + sicCode;
            }
            if (String.isNotBlank(status)) {
                if (String.isNotBlank(searchQuery)) {
                    searchQuery += ' AND ';
                }
                searchQuery += 'company_status:' + status;
            }
            
            if (String.isBlank(searchQuery)) {
                return new List<CompaniesHouse.Company>();
            }
            
            String endpoint = BASE_URL + SEARCH_ENDPOINT + '?q=' + EncodingUtil.urlEncode(searchQuery, 'UTF-8') + '&items_per_page=20&start_index=0';
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':')));
            request.setTimeout(15000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> items = (List<Object>) jsonResponse.get('items');
                
                List<CompaniesHouse.Company> companies = new List<CompaniesHouse.Company>();
                
                if (items != null) {
                    Integer count = 0;
                    for (Object item : items) {
                        Map<String, Object> companyMap = (Map<String, Object>) item;
                        CompaniesHouse.Company company = mapToCompany(companyMap);
                        
                        if (String.isNotBlank(company.company_name) && String.isNotBlank(company.company_number)) {
                            company.first_officer = getFirstOfficer(company.company_number, apiKey);
                            companies.add(company);
                            count++;
                            
                            // Limit to 20 companies to avoid callout limits
                            if (count >= 20) break;
                        }
                    }
                }
                
                return companies;
            } else {
                System.debug('Error response: ' + response.getBody());
                return new List<CompaniesHouse.Company>();
            }
            
        } catch (Exception e) {
            System.debug('Error in getCompaniesBySICAndStatus: ' + e.getMessage());
            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Clears the cache
     * @param apiKey Companies House API key (unused but required for consistency)
     */
    @AuraEnabled(cacheable=true)
    public static void clearCache(String apiKey) {
        cache.clear();
        cacheTimestamps.clear();
    }
    
    /**
     * @description Maps API response to Company object
     * @param companyMap Map from API response
     * @return CompaniesHouse.Company Company object
     */
    private static CompaniesHouse.Company mapToCompany(Map<String, Object> companyMap) {
        CompaniesHouse.Company company = new CompaniesHouse.Company();
        
        // Map basic fields
        company.company_name = (String) companyMap.get('company_name');
        company.company_number = (String) companyMap.get('company_number');
        company.company_status = (String) companyMap.get('company_status');
        company.date_of_incorporation = (String) companyMap.get('date_of_incorporation');
        company.type = (String) companyMap.get('type');
        
        // Map SIC codes
        Object sicCodesObj = companyMap.get('sic_codes');
        if (sicCodesObj != null) {
            if (sicCodesObj instanceof List<Object>) {
                List<Object> sicCodesList = (List<Object>) sicCodesObj;
                company.sic_codes = new List<String>();
                for (Object sicCode : sicCodesList) {
                    company.sic_codes.add(String.valueOf(sicCode));
                }
            } else if (sicCodesObj instanceof String) {
                company.sic_codes = new List<String>{(String) sicCodesObj};
            }
        }
        
        // Map registered office address
        Object addressObj = companyMap.get('registered_office_address');
        if (addressObj != null && addressObj instanceof Map<String, Object>) {
            Map<String, Object> addressMap = (Map<String, Object>) addressObj;
            company.registered_office_address = new CompaniesHouse.Address();
            company.registered_office_address.address_line_1 = (String) addressMap.get('address_line_1');
            company.registered_office_address.locality = (String) addressMap.get('locality');
            company.registered_office_address.region = (String) addressMap.get('region');
            company.registered_office_address.postal_code = (String) addressMap.get('postal_code');
            company.registered_office_address.country = (String) addressMap.get('country');
        }
        
        return company;
    }
    
    /**
     * @description Maps API response to Person object
     * @param personMap Map from API response
     * @return CompaniesHouse.Person Person object
     */
    private static CompaniesHouse.Person mapToPerson(Map<String, Object> personMap) {
        CompaniesHouse.Person person = new CompaniesHouse.Person();
        
        person.forename = (String) personMap.get('forename');
        person.surname = (String) personMap.get('surname');
        person.title = (String) personMap.get('title');
        person.phone_number = (String) personMap.get('phone_number');
        person.email = (String) personMap.get('email');
        
        return person;
    }
} 