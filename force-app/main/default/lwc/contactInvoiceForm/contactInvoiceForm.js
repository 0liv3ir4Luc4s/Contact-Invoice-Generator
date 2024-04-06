import { LightningElement } from 'lwc';
import EUR_PRICE from '@salesforce/schema/Invoice__c.BasePrice__c';
import EXPIRATION_DATE from '@salesforce/schema/Invoice__c.ExpirationDate__c';
import DESCRIPTION from '@salesforce/schema/Invoice__c.Description__c';

export default class ContactInvoiceForm extends LightningElement {
    EUR_PRICE_FIELD = EUR_PRICE;
    EXPIRATION_DATE_FIELD = EXPIRATION_DATE;
    DESCRIPTION_FIELD = DESCRIPTION;

    objectApiName = 'Invoice__c';
}