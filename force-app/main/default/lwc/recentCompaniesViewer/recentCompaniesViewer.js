import { LightningElement, api, track } from 'lwc';
import getRecentCompanies from '@salesforce/apex/CompaniesHouseController.getRecentCompanies';
import getCompaniesBySICAndStatus from '@salesforce/apex/CompaniesHouseController.getCompaniesBySICAndStatus';
import getSICCodeOptions from '@salesforce/apex/SICCodeHelper.getSICCodeOptions';
import searchSICCodes from '@salesforce/apex/SICCodeHelper.searchSICCodes';
import getCompanyStatusOptions from '@salesforce/apex/SICCodeHelper.getCompanyStatusOptions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchCompanies from '@salesforce/apex/CompaniesHouseController.searchCompanies';
import clearCache from '@salesforce/apex/CompaniesHouseController.clearCache';


export default class RecentCompaniesViewer extends LightningElement {
    @api bannerText = 'Discover the latest companies registered with Companies House';
    @api apiKey;
    @track companies = [];
    @track error;
    @track isLoading = true;
    @track isSearching = false;
    @track searchTerm = '';
    @track isSearchMode = false;

    // Filter properties
    @track selectedSICCode = '';
    @track selectedSICDescription = '';
    @track selectedCompanyStatuses = [];
    @track isFilterMode = false;

    // SIC Code dropdown properties
    @track sicCodeOptions = [];
    @track filteredSICOptions = [];
    @track showSICDropdown = false;
    @track sicSearchTerm = '';

    // Company Status dropdown properties
    @track companyStatusOptions = [];
    @track showStatusDropdown = false;

    // Pagination properties
    @track currentPage = 1;
    @api itemsPerPage = 6;

    get bannerImageUrl() {
        return '/resource/CH';
    }

    connectedCallback() {
        // Only load data if API key is provided
        if (this.apiKey) {
            this.loadInitialData();
            this.loadSICCodeOptions();
            this.loadCompanyStatusOptions();
        } else {
            this.isLoading = false;
            this.error = 'API Key is required. Please configure the component with your Companies House API key.';
        }
    }

    async loadInitialData() {
        try {
            this.isLoading = true;
            const data = await getRecentCompanies({ apiKey: this.apiKey });
            this.companies = data || [];
            this.error = undefined;
            
            // Trigger animation when companies load
            this.triggerLoadAnimation();
        } catch (error) {
            this.error = error;
            this.companies = [];
        } finally {
            this.isLoading = false;
        }
    }

    async loadSICCodeOptions() {
        try {
            const options = await getSICCodeOptions();
            this.sicCodeOptions = options.map(option => ({
                ...option,
                isSelected: false
            }));
        } catch (error) {

        }
    }

    async loadCompanyStatusOptions() {
        try {
            const statusOptions = await getCompanyStatusOptions();
            this.companyStatusOptions = statusOptions.map(option => ({
                ...option,
                isSelected: false
            }));
        } catch (error) {

        }
    }

    get hasCompanies() {
        return this.companies && this.companies.length > 0;
    }

    get hasError() {
        return this.error;
    }

    get totalCompanies() {
        return this.companies ? this.companies.length : 0;
    }

    get displayedCompanies() {
        if (!this.companies || this.companies.length === 0) {
            return [];
        }
        
        const startIndex = (this.currentPage - 1) * this.itemsPerPage;
        const endIndex = startIndex + this.itemsPerPage;
        return this.companies.slice(startIndex, endIndex);
    }

    get showPagination() {
        return this.totalCompanies > this.itemsPerPage;
    }

    get startIndex() {
        return (this.currentPage - 1) * this.itemsPerPage;
    }

    get endIndex() {
        return Math.min(this.startIndex + this.itemsPerPage, this.totalCompanies);
    }

    get displayStartIndex() {
        return this.startIndex + 1;
    }

    get displayEndIndex() {
        return this.endIndex;
    }

    get totalPages() {
        return Math.ceil(this.totalCompanies / this.itemsPerPage);
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    get pageNumbers() {
        const pages = [];
        const maxVisiblePages = 5;
        let startPage = Math.max(1, this.currentPage - Math.floor(maxVisiblePages / 2));
        let endPage = Math.min(this.totalPages, startPage + maxVisiblePages - 1);
        
        if (endPage - startPage + 1 < maxVisiblePages) {
            startPage = Math.max(1, endPage - maxVisiblePages + 1);
        }
        
        for (let i = startPage; i <= endPage; i++) {
            pages.push(i);
        }
        return pages;
    }

    get pageButtonClass() {
        return 'pagination-btn';
    }

    get selectedSICLabel() {
        if (this.selectedSICCode && this.selectedSICDescription) {
            return this.selectedSICCode + ' - ' + this.selectedSICDescription;
        }
        return 'Select Industry (SIC Code)';
    }

    get selectedStatusLabel() {
        const selectedCount = this.selectedCompanyStatuses.length;
        if (selectedCount === 0) {
            return 'Select Company Status';
        } else if (selectedCount === 1) {
            const status = this.companyStatusOptions.find(opt => opt.value === this.selectedCompanyStatuses[0]);
            return status ? status.label : this.selectedCompanyStatuses[0];
        } else {
            return `${selectedCount} statuses selected`;
        }
    }

    get selectedStatusOptions() {
        return this.companyStatusOptions.filter(option => 
            this.selectedCompanyStatuses.includes(option.value)
        );
    }

    getErrorMessage(error) {
        if (error && error.body && error.body.message) {
            return error.body.message;
        }
        return 'Unknown error occurred';
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    // SIC Code dropdown handlers
    handleSICDropdownClick() {
        this.showSICDropdown = !this.showSICDropdown;
        if (this.showSICDropdown) {
            this.filteredSICOptions = [...this.sicCodeOptions];
        }
    }

    handleSICSearchChange(event) {
        this.sicSearchTerm = event.target.value;
        this.filterSICOptions();
    }

    async filterSICOptions() {
        if (this.sicSearchTerm.trim() === '') {
            this.filteredSICOptions = [...this.sicCodeOptions];
        } else {
            try {
                this.filteredSICOptions = await searchSICCodes({ searchTerm: this.sicSearchTerm, apiKey: this.apiKey });
            } catch (error) {
    
                this.filteredSICOptions = [];
            }
        }
    }

    handleSICOptionSelect(event) {
        const selectedOption = event.currentTarget.dataset;
        this.selectedSICCode = selectedOption.code;
        this.selectedSICDescription = selectedOption.description;
        this.showSICDropdown = false;
        this.sicSearchTerm = '';
        this.filteredSICOptions = [...this.sicCodeOptions];
    }

    handleClearSIC() {
        this.selectedSICCode = '';
        this.selectedSICDescription = '';
    }

    // Company Status dropdown handlers
    handleStatusDropdownClick() {
        this.showStatusDropdown = !this.showStatusDropdown;
    }

    handleStatusOptionToggle(event) {
        const statusValue = event.target.dataset.value;
        const isChecked = event.target.checked;
        
        // Update the selected statuses array
        if (isChecked) {
            if (!this.selectedCompanyStatuses.includes(statusValue)) {
                this.selectedCompanyStatuses = [...this.selectedCompanyStatuses, statusValue];
            }
        } else {
            this.selectedCompanyStatuses = this.selectedCompanyStatuses.filter(status => status !== statusValue);
        }
        
        // Update the isSelected property for the specific option
        this.companyStatusOptions = this.companyStatusOptions.map(option => ({
            ...option,
            isSelected: this.selectedCompanyStatuses.includes(option.value)
        }));
    }

    handleClearStatuses() {
        this.selectedCompanyStatuses = [];
        // Reset all isSelected properties
        this.companyStatusOptions = this.companyStatusOptions.map(option => ({
            ...option,
            isSelected: false
        }));
    }

    // Filter handlers
    async handleApplyFilters() {
        this.isLoading = true;
        this.isFilterMode = true;
        this.currentPage = 1;

        try {
            // Determine which filters are active
            const hasSIC = this.selectedSICCode && this.selectedSICCode.trim() !== '';
            const hasStatus = this.selectedCompanyStatuses && this.selectedCompanyStatuses.length > 0;

            let filteredResults;

            // Use the most specific method based on which filters are active
            if (hasSIC && hasStatus) {
                // SIC + Status - use the first selected status
                filteredResults = await getCompaniesBySICAndStatus({
                    sicCode: this.selectedSICCode,
                    status: this.selectedCompanyStatuses[0],
                    apiKey: this.apiKey
                });
            } else if (hasSIC && !hasStatus) {
                // SIC only - use the combined method with empty status
                filteredResults = await getCompaniesBySICAndStatus({ 
                    sicCode: this.selectedSICCode, 
                    status: '', 
                    apiKey: this.apiKey 
                });
            } else if (!hasSIC && hasStatus) {
                // Status only - use the combined method with empty SIC
                filteredResults = await getCompaniesBySICAndStatus({ 
                    sicCode: '', 
                    status: this.selectedCompanyStatuses[0], 
                    apiKey: this.apiKey 
                });
            } else {
                // No filters - get recent companies
                filteredResults = await getRecentCompanies({ apiKey: this.apiKey });
            }

            this.companies = filteredResults || [];
            this.error = undefined;

            if (this.companies.length === 0) {
                this.showToast('No Results', 'No companies found with the selected filters', 'warning');
            } else {
                this.showToast('Success', `Found ${this.companies.length} companies with the selected filters`, 'success');
                // Trigger animation for filtered results
                this.triggerLoadAnimation();
            }
        } catch (error) {
            this.error = error;
            this.companies = [];
            this.showToast('Error', 'Failed to filter companies: ' + this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    async handleClearFilters() {
        this.selectedSICCode = '';
        this.selectedSICDescription = '';
        this.selectedCompanyStatuses = [];
        this.isFilterMode = false;
        this.currentPage = 1;

        // Reset SIC dropdown
        this.showSICDropdown = false;
        this.sicSearchTerm = '';
        this.filteredSICOptions = [...this.sicCodeOptions];

        // Reset status dropdown
        this.showStatusDropdown = false;
        this.companyStatusOptions = this.companyStatusOptions.map(option => ({
            ...option,
            isSelected: false
        }));

        // Refresh the view
        try {
            this.isLoading = true;
            const recentCompanies = await getRecentCompanies({ apiKey: this.apiKey });
            this.companies = recentCompanies || [];
            this.error = undefined;
            this.showToast('Success', 'Filters cleared and showing recent companies', 'success');
            // Trigger animation when clearing filters
            this.triggerLoadAnimation();
        } catch (error) {
            this.error = error;
            this.companies = [];
            this.showToast('Error', 'Failed to refresh companies: ' + this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    async handleSearch() {
        if (!this.searchTerm.trim()) {
            this.showToast('Error', 'Please enter a search term', 'error');
            return;
        }

        this.isSearching = true;
        this.isSearchMode = true;
        this.currentPage = 1;

        try {
            const searchResults = await searchCompanies({ searchTerm: this.searchTerm, apiKey: this.apiKey });
            this.companies = searchResults || [];
            this.error = undefined;

            if (this.companies.length === 0) {
                this.showToast('No Results', 'No companies found matching your search', 'warning');
            } else {
                this.showToast('Success', `Found ${this.companies.length} companies matching "${this.searchTerm}"`, 'success');
                // Trigger animation for search results
                this.triggerLoadAnimation();
            }
        } catch (error) {
            this.error = error;
            this.companies = [];
            this.showToast('Error', 'Search failed: ' + this.getErrorMessage(error), 'error');
        } finally {
            this.isSearching = false;
        }
    }

    async handleClearSearch() {
        this.searchTerm = '';
        this.isSearchMode = false;
        this.currentPage = 1;

        try {
            this.isLoading = true;
            const recentCompanies = await getRecentCompanies({ apiKey: this.apiKey });
            this.companies = recentCompanies || [];
            this.error = undefined;
            this.showToast('Success', 'Search cleared and showing recent companies', 'success');
            // Trigger animation when clearing search
            this.triggerLoadAnimation();
        } catch (error) {
            this.error = error;
            this.companies = [];
            this.showToast('Error', 'Failed to refresh companies: ' + this.getErrorMessage(error), 'error');
        } finally {
            this.isLoading = false;
        }
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    handlePageChange(event) {
        const pageNumber = parseInt(event.target.dataset.page);
        if (pageNumber >= 1 && pageNumber <= this.totalPages) {
            this.currentPage = pageNumber;
        }
    }

    async handleRefresh() {
        try {
            await clearCache({ apiKey: this.apiKey });
            this.showToast('Success', 'Cache cleared successfully', 'success');
            
            // Refresh the current view
            if (this.isSearchMode) {
                await this.handleSearch();
            } else if (this.isFilterMode) {
                await this.handleApplyFilters();
            } else {
                this.isLoading = true;
                const recentCompanies = await getRecentCompanies({ apiKey: this.apiKey });
                this.companies = recentCompanies || [];
                this.triggerLoadAnimation();
                this.isLoading = false;
            }
        } catch (error) {
            this.showToast('Error', 'Failed to clear cache: ' + this.getErrorMessage(error), 'error');
        }
    }

    triggerLoadAnimation() {
        // Add a small delay to ensure the DOM is updated
        setTimeout(() => {
            const companyCards = this.template.querySelectorAll('.company-card-wrapper');
            companyCards.forEach((card, index) => {
                card.style.animationDelay = `${(index + 1) * 0.1}s`;
            });
        }, 100);
    }
} 