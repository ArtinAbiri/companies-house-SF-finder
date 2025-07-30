import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createLeadFromCompany from '@salesforce/apex/CompaniesHouseController.createLeadFromCompany';
import createAccountFromCompany from '@salesforce/apex/CompaniesHouseController.createAccountFromCompany';

export default class CompanyCard extends NavigationMixin(LightningElement) {
    @api company;
    @api apiKey;
    
    isProcessing = false;
    recordId = null;
    recordType = null;
    showSuccess = false;

    get formattedAddress() {
        if (!this.company || !this.company.registered_office_address) {
            return null;
        }
        
        const address = this.company.registered_office_address;
        const parts = [];
        
        if (address.premises) parts.push(address.premises);
        if (address.address_line_1) parts.push(address.address_line_1);
        if (address.address_line_2) parts.push(address.address_line_2);
        if (address.locality) parts.push(address.locality);
        if (address.region) parts.push(address.region);
        if (address.postal_code) parts.push(address.postal_code);
        
        return parts.length > 0 ? parts.join(', ') : null;
    }

    get formattedIncorporationDate() {
        if (!this.company || !this.company.date_of_incorporation) {
            return 'N/A';
        }
        
        try {
            const dateParts = this.company.date_of_incorporation.split('-');
            if (dateParts.length >= 3) {
                const year = dateParts[0];
                const month = dateParts[1];
                const day = dateParts[2];
                return `${day}/${month}/${year}`;
            }
        } catch (error) {
            console.error('Error formatting incorporation date:', error);
        }
        
        return this.company.date_of_incorporation;
    }

    get statusBadgeClass() {
        if (!this.company || !this.company.company_status) {
            return '';
        }
        
        const status = this.company.company_status.toLowerCase();
        if (status.includes('active')) return 'status-active';
        if (status.includes('dissolved')) return 'status-dissolved';
        if (status.includes('liquidation')) return 'status-liquidation';
        if (status.includes('receivership')) return 'status-receivership';
        return '';
    }

    get hasOfficer() {
        return this.company && this.company.first_officer && this.company.first_officer.name;
    }

    get hasOfficerRole() {
        return this.hasOfficer && this.company.first_officer.role;
    }

    get officerDisplayName() {
        if (!this.hasOfficer) return '';
        
        const officer = this.company.first_officer;
        let displayName = officer.name;
        
        // Add occupation if available
        if (officer.occupation) {
            displayName += ` (${officer.occupation})`;
        }
        
        return displayName;
    }

    get buttonsDisabled() {
        return this.isProcessing || this.showSuccess;
    }

    get successMessage() {
        if (!this.recordId || !this.recordType) return '';
        return `${this.recordType} created successfully!`;
    }

    get companiesHouseUrl() {
        if (!this.company || !this.company.company_number) {
            return null;
        }
        
        return `https://find-and-update.company-information.service.gov.uk/company/${this.company.company_number}`;
    }

    get hasSicCodes() {
        return this.company && this.company.sic_codes && this.company.sic_codes.length > 0;
    }

    get sicCodesDisplay() {
        if (!this.hasSicCodes) return 'N/A';
        return this.company.sic_codes.join(', ');
    }

    handleCardClick(event) {
        // Prevent card click when clicking on buttons
        if (event.target.tagName === 'BUTTON' || event.target.closest('button')) {
            return;
        }
        
        // Navigate to Companies House website
        if (this.companiesHouseUrl) {
            window.open(this.companiesHouseUrl, '_blank');
        }
    }

    handleCreateLead(event) {
        event.stopPropagation();
        this.createRecord('Lead');
    }

    handleCreateAccount(event) {
        event.stopPropagation();
        this.createRecord('Account');
    }

    async createRecord(recordType) {
        try {
            this.isProcessing = true;
            this.showSuccess = false;
            this.recordId = null;
            this.recordType = null;
            
            const companyData = JSON.stringify(this.company);
            let result;
            
            if (recordType === 'Lead') {
                result = await createLeadFromCompany({ 
                    companyData: companyData,
                    apiKey: this.apiKey
                });
            } else {
                result = await createAccountFromCompany({ 
                    companyData: companyData,
                    apiKey: this.apiKey
                });
            }
            
            // Extract record ID from result
            const match = result.match(/([a-zA-Z0-9]{15,18})/);
            if (match) {
                this.recordId = match[1];
                this.recordType = recordType;
                this.showSuccess = true;
                
                this.showToast('Success', `${recordType} created successfully!`, 'success');
                
                // Hide success message after 5 seconds
                setTimeout(() => {
                    this.showSuccess = false;
                }, 5000);
            } else {
                this.showToast('Success', result, 'success');
            }
            
        } catch (error) {
            console.error('Error creating record:', error);
            this.showToast('Error', this.getErrorMessage(error), 'error');
        } finally {
            this.isProcessing = false;
        }
    }

    handleViewRecord(event) {
        if (!this.recordId) return;
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }

    getErrorMessage(error) {
        if (error && error.body && error.body.message) {
            return error.body.message;
        }
        return error ? error.message : 'An unknown error occurred';
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}