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

    handleCardClick(event) {
        // Don't trigger if clicking on buttons or success section
        const target = event.target;
        const isButton = target.closest('lightning-button') || target.closest('.card-footer') || target.closest('.success-section');
        
        if (!isButton && this.companiesHouseUrl) {
            window.open(this.companiesHouseUrl, '_blank');
        }
    }

    handleCreateLead(event) {
        event.stopPropagation(); // Prevent card click
        this.createRecord('Lead');
    }

    handleCreateAccount(event) {
        event.stopPropagation(); // Prevent card click
        this.createRecord('Account');
    }

    async createRecord(recordType) {
        this.isProcessing = true;
        this.recordType = recordType;
        
        try {
            const companyJSON = JSON.stringify(this.company);
            let recordId;
            
            if (recordType === 'Lead') {
                recordId = await createLeadFromCompany({ companyJSON, apiKey: this.apiKey });
            } else {
                recordId = await createAccountFromCompany({ companyJSON, apiKey: this.apiKey });
            }
            
            this.recordId = recordId;
            this.showSuccess = true;
            
            this.showToast('Success', `${recordType} created successfully!`, 'success');
            
        } catch (error) {

            this.showToast('Error', `Failed to create ${recordType}: ${error.body?.message || error.message}`, 'error');
        } finally {
            this.isProcessing = false;
        }
    }

    handleViewRecord(event) {
        event.stopPropagation(); // Prevent card click
        if (this.recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            });
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
} 