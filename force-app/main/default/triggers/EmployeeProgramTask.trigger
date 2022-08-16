trigger EmployeeProgramTask on Employee_Program_Task__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        UpdateDueDateForIndivTasks.updateDueDates(Trigger.new);
    }
    
}