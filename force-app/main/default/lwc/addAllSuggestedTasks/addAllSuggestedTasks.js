import { LightningElement, api, track, wire } from 'lwc';
import getRelatedTask from '@salesforce/apex/TaskSelectedController.getRelatedTask'
import assignSelectedTaskToProgram from '@salesforce/apex/TaskSelectedController.assignSelectedTaskToProgram'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Name from '@salesforce/schema/Training_Task__c.Name';
import retriveTasks from '@salesforce/apex/TaskSelectedController.retriveTasks';
import { refreshApex } from '@salesforce/apex';
import fetchAssignedPrograms from '@salesforce/apex/TaskSelectedController.fetchAssignedPrograms';
import deleteSelectedTasks from '@salesforce/apex/TaskSelectedController.deleteSelectedTasks';

const columns = [
    { label: 'Tasks Name', fieldName: 'Name' },
    { label: 'Category', fieldName: 'Team_Category__c' },
];

export default class AddAllSuggestedTasks extends LightningElement {
   @track showModal = false;
   @track columns = columns;
   @track errorMsg = '';
   @track searchData;
   data;
   
   @api recordId;

    modalShown = false;
    nameField = Name;
    tasks;
    selectedTasks = [];
    strSearchTaskName ='';
    selectedRecords = [];

    

    //relatedTasksResult;

   col = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Category', fieldName: 'Team_Category__c' },
        { label: 'Days to Complete', fieldName: 'No_of_Days_to_Complete__c'},
      
    ];

   /*
    @wire(getRelatedTask, {programId: '$recordId'})
    wiredRelatedTasks(result){
        this.relatedTasksResult = result;
        if(result.data){
            this.tasks = result.data;
            this.error = undefined;
        }
        else if(result.error){
            this.error = result.error;
            this.tasks = undefined;
        }
    }
    */
    GetRelatedTask() {
        getRelatedTask({ programId: this.recordId })
        .then(tasks => {
            console.log(tasks);
            this.tasks = tasks;
        })
        .catch(error => {
            console.warn(error);
        })
    } 

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedTasks = [];
        for(let i = 0; i<selectedRows.length; i++) {
            this.selectedTasks.push(selectedRows[i].Id);
        }
        console.log(this.selectedTasks);
    }

    get isButtonDisabled() {
        return this.selectedTasks.length === 0;
    }
    
    handleAssignSelectedTaskToProgram() {
        assignSelectedTaskToProgram({taskIn: this.selectedTasks, programId: this.recordId})
        .then(response => {
            console.log(selectedTasks);
           // return refreshApex(this.relatedTasksResult);
        })
        .catch(error => {
            console.warn(error);
        });
    }
    
    handleSuccess(event) {
        let allModals = this.template.querySelectorAll('c-modal')[0];
        allModals.toggleModal();
        

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: 'New Task created successfully!',
            variant: 'success',
        }));
    }
    
    toggleModal() {
        this.modalShown = !this.modalShown;
    }
    
    
    handleTaskName(event) {
        this.strSearchTaskName = event.detail.value;
        console.log(this.strSearchTaskName);
    }

    handleSearch() {
        if(!this.strSearchTaskName) {
            this.errorMsg = 'Please enter Task name to search.';
            this.searchData = undefined;
            return;
        }

    retriveTasks({taskName : this.strSearchTaskName})
    .then(result => {
         /*  result.forEach((record) => {
                record.Name = '/' + record.Id;
                console.log("its inside retriveTasks");
                console.log(record.Name);
            }); */
            
        this.searchData = result;
        console.log(this.searchData)
            
    })
    .catch(error => {
        this.searchData = undefined;
        window.console.log('error =====> '+JSON.stringify(error));
        if(error) {
            this.errorMsg = error.body.message;
        }
        }) 
    }

    @wire(fetchAssignedPrograms,{projectId: '$recordId'})
    programs(results) {
        this.refreshTable = results;
        //console.log(this.data);
        if (results.data) {
            this.data = results.data;
            this.error = undefined;
        } else if (results.error) {
            this.error = results.error;
            this.data = undefined;
        }
    }
    getSelectedRecords(event) {

        let selectedRows = event.detail.selectedRows;
        this.selectedRecords = selectedRows;

        // this.recordsCount = event.detail.selectedRows.length;
        // this.selectedRecords=new Array();
        // for (let i = 0; i < selectedRows.length; i++) {
        //     this.selectedRecords.push(selectedRows[i]);
        // }
    }
    deleteRecords() {
        
            this.buttonLabel = 'Processing....';
            this.isTrue = true;
            deleteSelectedTasks({assignedPrograms: this.selectedRecords }).then(result => {
                window.console.log('result ====> ' + result);
                this.buttonLabel = 'Delete Records';
                this.isTrue = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: ' records are deleted.',
                        variant: 'success'
                    }),
                );
                this.template.querySelector('lightning-datatable').selectedRows = [];
                this.recordsCount = 0;
                return refreshApex(this.refreshTable);
            }).catch(error => {
                this.buttonLabel = 'Delete Records';
                this.isTrue = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while deleting Program assignments',
                        message: 'error while deleting',
                        variant: 'error'
                    }),
                );
            });
        
    }
}
