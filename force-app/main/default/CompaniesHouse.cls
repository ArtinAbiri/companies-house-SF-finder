/**
 * @description Wrapper class for Companies House API response
 * @author System
 * @date 2025-01-25
 */
public with sharing class CompaniesHouse {
    
    @AuraEnabled public List<Company> companies { get; set; }
    @AuraEnabled public Integer total_results { get; set; }
    
    public class Company {
        @AuraEnabled public String company_name { get; set; }
        @AuraEnabled public String company_number { get; set; }
        @AuraEnabled public String date_of_incorporation { get; set; }
        @AuraEnabled public String company_status { get; set; }
        @AuraEnabled public Address registered_office_address { get; set; }
        @AuraEnabled public String company_type { get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String jurisdiction { get; set; }
        @AuraEnabled public Person first_officer { get; set; }
        @AuraEnabled public List<String> sic_codes { get; set; }
    }
    
    public class Address {
        @AuraEnabled public String address_line_1 { get; set; }
        @AuraEnabled public String address_line_2 { get; set; }
        @AuraEnabled public String locality { get; set; }
        @AuraEnabled public String region { get; set; }
        @AuraEnabled public String postal_code { get; set; }
        @AuraEnabled public String country { get; set; }
        @AuraEnabled public String premises { get; set; }
    }
    
    public class Person {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String role { get; set; }
        @AuraEnabled public String date_of_birth { get; set; }
        @AuraEnabled public Address address { get; set; }
        @AuraEnabled public String nationality { get; set; }
        @AuraEnabled public String occupation { get; set; }
        @AuraEnabled public String forename { get; set; }
        @AuraEnabled public String surname { get; set; }
        @AuraEnabled public String title { get; set; }
        @AuraEnabled public String phone_number { get; set; }
        @AuraEnabled public String email { get; set; }
    }
} 