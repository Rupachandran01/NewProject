trigger UpdateDueDateEmployeeProgramTask on Employee_Program_Task__c (before insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        UpdateDueDateForIndivTasks.updateDueDates(Trigger.new);
    }

}