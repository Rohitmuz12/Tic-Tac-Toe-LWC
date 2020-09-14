import { LightningElement, api,track,wire } from 'lwc';
import getContactByAccountId from '@salesforce/apex/LwcComponentController.getAllContactsByAccountId'

const columns = [{label:'First Name', fieldName : 'FirstName'},
                        {label:'Last Name', fieldName : 'LastName'}];


export default class QuickOne extends LightningElement {
    @api recordId;
    @track selectedAssignment = false;
    @track selectAdd = false;
    @track testText = 'Hello';
    @track columns = columns;
    @track check = 'check';
    

    @wire(getContactByAccountId, {accountId : '$recordId'}) contactList1;

    openAddModal(){
        
        this.selectAdd = true;
    }

    closeAddModal(){
        this.selectAdd = false;
    }

    openAssignmentModal(){
        this.testText = this.recordId;
        
        this.selectedAssignment = true;
    }

    closeAssignmentModal(){
        this.selectedAssignment = false;
    }

    get hasResult(){
        this.contactList = this.contactList1.data;
        return (this.contactList.length > 0);
    }

    getSelectedContact(event) {
        const selectedRow = event.detail.selectedRows;
        console.log(selectedRow);
        this.check = selectedRow[0].FirstName;
        for(let i = 0; i < selectedRow.length; i++){
            alert('You select ' + selectedRow[i].FirstName);
        }
    }

}