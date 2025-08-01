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
            Set<String> addedCompanyNumbers = new Set<String>(); // Track added companies to avoid duplicates
            
            // Use a more intelligent approach to get diverse companies
            // Instead of specific search terms, we'll use various strategies
            
            // Strategy 1: Search by random company numbers (Companies House uses 8-digit numbers)
            List<String> randomCompanyNumbers = new List<String>();
            for (Integer i = 0; i < 20; i++) {
                // Generate random 8-digit numbers
                Integer randomNum = Math.mod((Integer)(Math.random() * 100000000), 99999999) + 10000000;
                randomCompanyNumbers.add(String.valueOf(randomNum));
            }
            
            // Strategy 2: Search by random letters (single characters)
            List<String> randomLetters = new List<String>{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
            
            // Strategy 3: Search by incorporation dates
            List<String> incorporationYears = new List<String>{'2025', '2024', '2023', '2022', '2021', '2020'};
            
            // Strategy 4: Search by company status
            List<String> companyStatuses = new List<String>{'active', 'registered'};
            
            // Combine all strategies
            List<String> searchStrategies = new List<String>();
            
            // Add random company numbers
            for (String companyNum : randomCompanyNumbers) {
                searchStrategies.add(companyNum);
            }
            
            // Add random letters
            for (Integer i = 0; i < 15; i++) {
                Integer randomIndex = Math.mod((Integer)(Math.random() * 1000000), randomLetters.size());
                searchStrategies.add(randomLetters[randomIndex]);
            }
            
            // Add incorporation years
            for (String year : incorporationYears) {
                searchStrategies.add('incorporated ' + year);
            }
            
            // Add company status searches
            for (String status : companyStatuses) {
                searchStrategies.add(status);
            }
            
            // Shuffle all strategies for better variety
            for (Integer i = searchStrategies.size() - 1; i > 0; i--) {
                Integer j = Math.mod((Integer)(Math.random() * 1000000), i + 1);
                String temp = searchStrategies[i];
                searchStrategies[i] = searchStrategies[j];
                searchStrategies[j] = temp;
            }
            
            for (String query : searchStrategies) {
                // Use different search strategies based on query type
                String endpoint;
                if (query.length() == 8 && query.isNumeric()) {
                    // For company numbers, search directly
                    endpoint = BASE_URL + '/company/' + query;
                } else {
                    // For other queries, use the search endpoint
                    endpoint = BASE_URL + SEARCH_ENDPOINT + '?q=' + EncodingUtil.urlEncode(query, 'UTF-8') + '&items_per_page=100&start_index=0';
                }
                
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endpoint);
                request.setMethod('GET');
                request.setHeader('Accept', 'application/json');
                request.setHeader('Authorization', apiKey);
                request.setTimeout(15000);
                
                Http http = new Http();
                HttpResponse response = http.send(request);
                
                if (response.getStatusCode() == 200) {
                    String responseBody = response.getBody();
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                    
                    // Handle different response types
                    if (query.length() == 8 && query.isNumeric()) {
                        // Direct company lookup - single company
                        CompaniesHouse.Company company = mapToCompany(jsonResponse);
                        
                        if (String.isNotBlank(company.company_name) && 
                            String.isNotBlank(company.company_number) &&
                            (company.company_status == 'active' || company.company_status == 'registered') &&
                            !addedCompanyNumbers.contains(company.company_number)) {
                            
                            company.first_officer = getFirstOfficer(company.company_number, apiKey);
                            allCompanies.add(company);
                            addedCompanyNumbers.add(company.company_number);
                        }
                    } else {
                        // Search results - multiple companies
                        List<Object> items = (List<Object>) jsonResponse.get('items');
                        
                        if (items != null) {
                            for (Object item : items) {
                                Map<String, Object> companyMap = (Map<String, Object>) item;
                                CompaniesHouse.Company company = mapToCompany(companyMap);
                                
                                // Only include companies with valid names, active status, and not already added
                                if (String.isNotBlank(company.company_name) && 
                                    String.isNotBlank(company.company_number) &&
                                    (company.company_status == 'active' || company.company_status == 'registered') &&
                                    !addedCompanyNumbers.contains(company.company_number)) {
                                    
                                    // Get the first officer for this company
                                    company.first_officer = getFirstOfficer(company.company_number, apiKey);
                                    
                                    allCompanies.add(company);
                                    addedCompanyNumbers.add(company.company_number);
                                    
                                    // Stop if we have enough companies
                                    if (allCompanies.size() >= MAX_RESULTS) break;
                                }
                            }
                        }
                    }
                }
                
                // Stop if we have enough companies
                if (allCompanies.size() >= MAX_RESULTS) break;
            }
            
            // Store in cache
            cache.put(cacheKey, allCompanies);
            cacheTimestamps.put(cacheKey, DateTime.now());
            
            return allCompanies;
            
        } catch (Exception e) {

            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Clears the cache to force fresh data retrieval
     * @return Boolean Success status
     */
    @AuraEnabled
    public static Boolean clearCache() {
        try {
            cache.clear();
            cacheTimestamps.clear();
            return true;
        } catch (Exception e) {
            return false;
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
            String endpoint = BASE_URL + '/company/' + companyNumber + '/officers?items_per_page=5&start_index=0';
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', apiKey);
            request.setTimeout(15000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> items = (List<Object>) jsonResponse.get('items');
                
                if (items != null && !items.isEmpty()) {
                    // Find the first active officer (preferably director)
                    for (Object item : items) {
                        Map<String, Object> officerMap = (Map<String, Object>) item;
                        String officerRole = (String) officerMap.get('officer_role');
                        
                        // Prefer directors, but take any officer if no director found
                        if (officerRole != null && (officerRole.toLowerCase().contains('director') || 
                                                   officerRole.toLowerCase().contains('secretary') ||
                                                   officerRole.toLowerCase().contains('member'))) {
                            return mapToPerson(officerMap);
                        }
                    }
                    
                    // If no preferred role found, take the first officer
                    Map<String, Object> officerMap = (Map<String, Object>) items[0];
                    return mapToPerson(officerMap);
                }
            }
            
        } catch (Exception e) {
            // Log error but don't throw - officer info is optional
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
            request.setHeader('Authorization', apiKey);
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

                return new List<CompaniesHouse.Company>();
            }
            
        } catch (Exception e) {

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
            // Companies House API doesn't support individual sic_codes: or company_status: filters
            // We need to use a different strategy based on what filters are provided
            
            List<CompaniesHouse.Company> allCompanies;
            
            if (String.isNotBlank(sicCode) && String.isNotBlank(status)) {
                // Both filters: Use a broader search and filter results
                allCompanies = searchAndFilterCompanies('active', sicCode, status, apiKey);
            } else if (String.isNotBlank(sicCode)) {
                // SIC only: Get recent companies and filter by SIC
                allCompanies = getRecentCompanies(apiKey);
                allCompanies = filterCompaniesBySIC(allCompanies, sicCode, apiKey);
            } else if (String.isNotBlank(status)) {
                // Status only: Get recent companies and filter by status
                allCompanies = getRecentCompanies(apiKey);
                allCompanies = filterCompaniesByStatus(allCompanies, status);
            } else {
                // No filters: return recent companies
                allCompanies = getRecentCompanies(apiKey);
            }
            
            return allCompanies != null ? allCompanies : new List<CompaniesHouse.Company>();
            
        } catch (Exception e) {

            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Search and filter companies by SIC and status
     * @param searchTerm General search term to use
     * @param sicCode SIC code to filter by
     * @param status Company status to filter by  
     * @param apiKey Companies House API key
     * @return List<CompaniesHouse.Company> Filtered companies
     */
    private static List<CompaniesHouse.Company> searchAndFilterCompanies(String searchTerm, String sicCode, String status, String apiKey) {
        try {
            // Use a broad search to get companies
            List<CompaniesHouse.Company> companies = searchCompanies(searchTerm, apiKey);
            
            // Filter by SIC code if specified
            if (String.isNotBlank(sicCode)) {
                companies = filterCompaniesBySIC(companies, sicCode, apiKey);
            }
            
            // Filter by status if specified
            if (String.isNotBlank(status)) {
                companies = filterCompaniesByStatus(companies, status);
            }
            
            return companies;
        } catch (Exception e) {

            return new List<CompaniesHouse.Company>();
        }
    }
    
    /**
     * @description Filter companies by SIC code using search
     * @param companies List of companies to filter
     * @param sicCode SIC code to filter by
     * @param apiKey API key for additional company details
     * @return List<CompaniesHouse.Company> Filtered companies
     */
    private static List<CompaniesHouse.Company> filterCompaniesBySIC(List<CompaniesHouse.Company> companies, String sicCode, String apiKey) {
        // Instead of making individual API calls, use a targeted search for the SIC code
        // This is more efficient and avoids hitting callout limits
        
        try {
            // Get SIC code description for search
            String sicDescription = SICCodeHelper.getSICCodeDescription(sicCode);
            
            if (String.isNotBlank(sicDescription)) {
                // Search using keywords from the SIC description
                String[] keywords = sicDescription.split(' ');
                String searchTerm = keywords.size() > 0 ? keywords[0] : sicCode;
                
                // Use search to find companies related to this SIC code
                List<CompaniesHouse.Company> sicCompanies = searchCompanies(searchTerm, apiKey);
                
                // Filter by status if original companies have status filter
                if (companies != null && companies.size() > 0) {
                    String firstCompanyStatus = companies[0].company_status;
                    if (String.isNotBlank(firstCompanyStatus)) {
                        sicCompanies = filterCompaniesByStatus(sicCompanies, firstCompanyStatus);
                    }
                }
                
                return sicCompanies != null ? sicCompanies : new List<CompaniesHouse.Company>();
            } else {
                // Fallback: return a subset of original companies
                List<CompaniesHouse.Company> limitedCompanies = new List<CompaniesHouse.Company>();
                Integer maxResults = Math.min(companies.size(), 10);
                for (Integer i = 0; i < maxResults; i++) {
                    limitedCompanies.add(companies[i]);
                }
                return limitedCompanies;
            }
        } catch (Exception e) {

            // Fallback: return a subset of original companies
            List<CompaniesHouse.Company> limitedCompanies = new List<CompaniesHouse.Company>();
            Integer maxResults = Math.min(companies.size(), 10);
            for (Integer i = 0; i < maxResults; i++) {
                limitedCompanies.add(companies[i]);
            }
            return limitedCompanies;
        }
    }
    
    /**
     * @description Filter companies by status
     * @param companies List of companies to filter
     * @param status Company status to filter by
     * @return List<CompaniesHouse.Company> Filtered companies
     */
    private static List<CompaniesHouse.Company> filterCompaniesByStatus(List<CompaniesHouse.Company> companies, String status) {
        List<CompaniesHouse.Company> filteredCompanies = new List<CompaniesHouse.Company>();
        
        for (CompaniesHouse.Company company : companies) {
            if (String.isNotBlank(company.company_status) && company.company_status.equalsIgnoreCase(status)) {
                filteredCompanies.add(company);
            }
        }
        
        return filteredCompanies;
    }
    

    
    /**
     * @description Maps API response to Company object
     * @param companyMap Map from API response
     * @return CompaniesHouse.Company Company object
     */
    private static CompaniesHouse.Company mapToCompany(Map<String, Object> companyMap) {
        CompaniesHouse.Company company = new CompaniesHouse.Company();
        
        // Map basic fields
        company.company_name = (String) companyMap.get('title'); // API returns 'title' not 'company_name'
        company.company_number = (String) companyMap.get('company_number');
        company.company_status = (String) companyMap.get('company_status');
        company.date_of_incorporation = (String) companyMap.get('date_of_creation'); // API returns 'date_of_creation'
        company.company_type = (String) companyMap.get('company_type'); // API returns 'company_type'
        company.type = company.company_type; // Set both for compatibility
        
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
        Object addressObj = companyMap.get('address');
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
        
        // Map name field - Companies House API returns 'name' for officers
        person.name = (String) personMap.get('name');
        
        // Map role - Companies House API returns 'officer_role'
        person.role = (String) personMap.get('officer_role');
        
        // Map nationality - Companies House API returns 'nationality'
        person.nationality = (String) personMap.get('nationality');
        
        // Map occupation - Companies House API returns 'occupation'
        person.occupation = (String) personMap.get('occupation');
        
        // Map date of birth - Companies House API returns 'date_of_birth' as object
        Object dobObj = personMap.get('date_of_birth');
        if (dobObj != null && dobObj instanceof Map<String, Object>) {
            Map<String, Object> dobMap = (Map<String, Object>) dobObj;
            Integer year = (Integer) dobMap.get('year');
            Integer month = (Integer) dobMap.get('month');
            if (year != null && month != null) {
                person.date_of_birth = year + '-' + String.valueOf(month).leftPad(2, '0') + '-01';
            }
        }
        
        // Map address - Companies House API returns 'address' as object
        Object addressObj = personMap.get('address');
        if (addressObj != null && addressObj instanceof Map<String, Object>) {
            Map<String, Object> addressMap = (Map<String, Object>) addressObj;
            person.address = new CompaniesHouse.Address();
            person.address.address_line_1 = (String) addressMap.get('address_line_1');
            person.address.address_line_2 = (String) addressMap.get('address_line_2');
            person.address.locality = (String) addressMap.get('locality');
            person.address.region = (String) addressMap.get('region');
            person.address.postal_code = (String) addressMap.get('postal_code');
            person.address.country = (String) addressMap.get('country');
            person.address.premises = (String) addressMap.get('premises');
        }
        
        // Additional fields (may not be present in Companies House API)
        person.forename = (String) personMap.get('forename');
        person.surname = (String) personMap.get('surname');
        person.title = (String) personMap.get('title');
        person.phone_number = (String) personMap.get('phone_number');
        person.email = (String) personMap.get('email');
        
        return person;
    }
    
    /**
     * @description Creates a Lead record from company data
     * @param companyJSON JSON string of company data
     * @param apiKey The Companies House API key
     * @return String ID of the created Lead record
     */
    @AuraEnabled
    public static String createLeadFromCompany(String companyJSON, String apiKey) {
        try {
            CompaniesHouse.Company company = (CompaniesHouse.Company) JSON.deserialize(companyJSON, CompaniesHouse.Company.class);
            
            Lead newLead = new Lead();
            newLead.Company = company.company_name;
            
            // Use first officer as the lead name
            if (company.first_officer != null && company.first_officer.name != null) {
                String fullName = company.first_officer.name;
                
                // Try to split name into first and last name
                List<String> nameParts = fullName.split(' ');
                if (nameParts.size() >= 2) {
                    newLead.FirstName = nameParts[0];
                    List<String> lastNameParts = new List<String>();
                    for (Integer i = 1; i < nameParts.size(); i++) {
                        lastNameParts.add(nameParts[i]);
                    }
                    newLead.LastName = String.join(lastNameParts, ' ');
                } else {
                    newLead.LastName = fullName;
                }
                
                // Add officer title if available
                if (company.first_officer.role != null) {
                    newLead.Title = company.first_officer.role;
                }
            } else {
                // Fallback to company name if no officer
                newLead.LastName = company.company_name;
                newLead.Title = 'Company Representative';
            }
            
            newLead.Status = 'Open - Not Contacted';
            newLead.Country = 'United Kingdom';
            
            // Map address fields if available
            if (company.registered_office_address != null) {
                CompaniesHouse.Address address = company.registered_office_address;
                newLead.Street = buildStreetAddress(address);
                newLead.City = address.locality;
                newLead.State = address.region;
                newLead.PostalCode = address.postal_code;
            }
            
            // Add custom fields for tracking (if they exist)
            if (hasField(Lead.SObjectType, 'Company_Number__c')) {
                newLead.put('Company_Number__c', company.company_number);
            }
            
            if (hasField(Lead.SObjectType, 'Incorporation_Date__c')) {
                newLead.put('Incorporation_Date__c', parseIncorporationDate(company.date_of_incorporation));
            }
            
            // Add officer information if available
            if (company.first_officer != null) {
                if (hasField(Lead.SObjectType, 'First_Officer_Name__c')) {
                    newLead.put('First_Officer_Name__c', company.first_officer.name);
                }
                if (hasField(Lead.SObjectType, 'First_Officer_Role__c')) {
                    newLead.put('First_Officer_Role__c', company.first_officer.role);
                }
                if (hasField(Lead.SObjectType, 'First_Officer_Occupation__c')) {
                    newLead.put('First_Officer_Occupation__c', company.first_officer.occupation);
                }
            }
            
            insert newLead;
            return newLead.Id;
            
        } catch (Exception e) {

            throw new AuraHandledException('Failed to create Lead: ' + e.getMessage());
        }
    }
    
    /**
     * @description Creates an Account record from company data with a Contact for the first officer
     * @param companyJSON JSON string of company data
     * @param apiKey The Companies House API key
     * @return String ID of the created Account record
     */
    @AuraEnabled
    public static String createAccountFromCompany(String companyJSON, String apiKey) {
        try {
            CompaniesHouse.Company company = (CompaniesHouse.Company) JSON.deserialize(companyJSON, CompaniesHouse.Company.class);
            
            Account newAccount = new Account();
            newAccount.Name = company.company_name;
            newAccount.BillingCountry = 'United Kingdom';
            
            // Map address fields if available
            if (company.registered_office_address != null) {
                CompaniesHouse.Address address = company.registered_office_address;
                newAccount.BillingStreet = buildStreetAddress(address);
                newAccount.BillingCity = address.locality;
                newAccount.BillingState = address.region;
                newAccount.BillingPostalCode = address.postal_code;
            }
            
            // Add custom fields for tracking (if they exist)
            if (hasField(Account.SObjectType, 'Company_Number__c')) {
                newAccount.put('Company_Number__c', company.company_number);
            }
            
            if (hasField(Account.SObjectType, 'Incorporation_Date__c')) {
                newAccount.put('Incorporation_Date__c', parseIncorporationDate(company.date_of_incorporation));
            }
            
            // Add officer information if available
            if (company.first_officer != null) {
                if (hasField(Account.SObjectType, 'First_Officer_Name__c')) {
                    newAccount.put('First_Officer_Name__c', company.first_officer.name);
                }
                if (hasField(Account.SObjectType, 'First_Officer_Role__c')) {
                    newAccount.put('First_Officer_Role__c', company.first_officer.role);
                }
                if (hasField(Account.SObjectType, 'First_Officer_Occupation__c')) {
                    newAccount.put('First_Officer_Occupation__c', company.first_officer.occupation);
                }
            }
            
            insert newAccount;
            
            // Create a Contact for the first officer if available
            if (company.first_officer != null && company.first_officer.name != null) {
                Contact newContact = new Contact();
                newContact.AccountId = newAccount.Id;
                
                String fullName = company.first_officer.name;
                
                // Try to split name into first and last name
                List<String> nameParts = fullName.split(' ');
                if (nameParts.size() >= 2) {
                    newContact.FirstName = nameParts[0];
                    List<String> lastNameParts = new List<String>();
                    for (Integer i = 1; i < nameParts.size(); i++) {
                        lastNameParts.add(nameParts[i]);
                    }
                    newContact.LastName = String.join(lastNameParts, ' ');
                } else {
                    newContact.LastName = fullName;
                }
                
                newContact.Title = company.first_officer.role;
                
                // Map officer address if available
                if (company.first_officer.address != null) {
                    CompaniesHouse.Address address = company.first_officer.address;
                    newContact.MailingStreet = buildStreetAddress(address);
                    newContact.MailingCity = address.locality;
                    newContact.MailingState = address.region;
                    newContact.MailingPostalCode = address.postal_code;
                    newContact.MailingCountry = address.country;
                }
                
                // Add custom fields for officer information
                if (hasField(Contact.SObjectType, 'Occupation__c')) {
                    newContact.put('Occupation__c', company.first_officer.occupation);
                }
                if (hasField(Contact.SObjectType, 'Nationality__c')) {
                    newContact.put('Nationality__c', company.first_officer.nationality);
                }
                if (hasField(Contact.SObjectType, 'Date_of_Birth__c')) {
                    newContact.put('Date_of_Birth__c', parseDateOfBirth(company.first_officer.date_of_birth));
                }
                
                insert newContact;
            }
            
            return newAccount.Id;
            
        } catch (Exception e) {

            throw new AuraHandledException('Failed to create Account: ' + e.getMessage());
        }
    }
    
    /**
     * @description Builds a complete street address from address components
     * @param address Address object
     * @return String Complete street address
     */
    private static String buildStreetAddress(CompaniesHouse.Address address) {
        List<String> addressParts = new List<String>();
        
        if (String.isNotBlank(address.premises)) {
            addressParts.add(address.premises);
        }
        if (String.isNotBlank(address.address_line_1)) {
            addressParts.add(address.address_line_1);
        }
        if (String.isNotBlank(address.address_line_2)) {
            addressParts.add(address.address_line_2);
        }
        
        return String.join(addressParts, ', ');
    }
    
    /**
     * @description Parses incorporation date string to Date
     * @param dateString Date string from API
     * @return Date Parsed date
     */
    private static Date parseIncorporationDate(String dateString) {
        if (String.isBlank(dateString)) return null;
        
        try {
            // Assuming format YYYY-MM-DD
            List<String> dateParts = dateString.split('-');
            if (dateParts.size() >= 3) {
                Integer year = Integer.valueOf(dateParts[0]);
                Integer month = Integer.valueOf(dateParts[1]);
                Integer day = Integer.valueOf(dateParts[2]);
                return Date.newInstance(year, month, day);
            }
        } catch (Exception e) {

        }
        
        return null;
    }

    /**
     * @description Parses date of birth string to Date
     * @param dateString Date string from API
     * @return Date Parsed date
     */
    private static Date parseDateOfBirth(String dateString) {
        if (String.isBlank(dateString)) return null;

        try {
            // Assuming format YYYY-MM-DD
            List<String> dateParts = dateString.split('-');
            if (dateParts.size() >= 3) {
                Integer year = Integer.valueOf(dateParts[0]);
                Integer month = Integer.valueOf(dateParts[1]);
                Integer day = Integer.valueOf(dateParts[2]);
                return Date.newInstance(year, month, day);
            }
        } catch (Exception e) {

        }

        return null;
    }
    
    /**
     * @description Checks if a field exists on an SObject type
     * @param objectType SObjectType to check
     * @param fieldName API name of the field
     * @return Boolean True if field exists
     */
    private static Boolean hasField(SObjectType objectType, String fieldName) {
        Map<String, SObjectField> fieldsMap = objectType.getDescribe().fields.getMap();
        return fieldsMap.containsKey(fieldName.toLowerCase());
    }
} 