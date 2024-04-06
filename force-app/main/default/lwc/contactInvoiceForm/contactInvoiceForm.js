import { LightningElement, api } from 'lwc';
import EUR_PRICE from '@salesforce/schema/Invoice__c.BasePrice__c';
import EXPIRATION_DATE from '@salesforce/schema/Invoice__c.ExpirationDate__c';
import DESCRIPTION from '@salesforce/schema/Invoice__c.Description__c';
import CONTACT from '@salesforce/schema/Invoice__c.Contact__c';

export default class ContactInvoiceForm extends LightningElement {
    EUR_PRICE_FIELD = EUR_PRICE;
    EXPIRATION_DATE_FIELD = EXPIRATION_DATE;
    DESCRIPTION_FIELD = DESCRIPTION;

    @api recordId;
    objectApiName = 'Invoice__c';

    handleFocus(event) {
        event.currentTarget.nextElementSibling.focus();
    }

    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Description__c = this.template.querySelector('.description').value;
        fields.Contact__c = this.recordId;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
     }
}