import { LightningElement, api } from 'lwc';
import NUMBER_OF_PAST_INVOICES from '@salesforce/schema/Contact.InvoiceCount__c';
import NUMBER_OF_OPEN_INVOICES from '@salesforce/schema/Contact.OpenAndNotExpiredInvoiceCount__c';
import TOTAL_AMOUNT_PAID from '@salesforce/schema/Contact.TotalAmountPaid__c';

export default class ContactInvoiceFormContactRollUpView extends LightningElement {
    NUMBER_OF_PAST_INVOICES_FIELD = NUMBER_OF_PAST_INVOICES;
    NUMBER_OF_OPEN_INVOICES_FIELD = NUMBER_OF_OPEN_INVOICES;
    TOTAL_AMOUNT_PAID_FIELD = TOTAL_AMOUNT_PAID;
    @api recordId;
}